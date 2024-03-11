import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Application/Menus/View/Single/View/single_page.dart';
import 'package:i_billing/Application/Menus/View/menus_widgets.dart';
import 'package:i_billing/Configuration/app_data_time.dart';
import 'package:i_billing/Data/Model/contract_model.dart';
import 'package:i_billing/Data/Model/history_model.dart';
import 'package:i_billing/Data/Model/invoice_model.dart';
import 'package:i_billing/Data/Model/user_model.dart';
import 'package:i_billing/Data/Service/db_service.dart';
import 'package:i_billing/Data/Service/lang_service.dart';
import 'package:i_billing/Data/Service/logic_service.dart';
import 'package:i_billing/Data/Service/r_t_d_b_service.dart';
import 'package:i_billing/Data/Service/util_service.dart';

part 'contracts_event.dart';
part 'contracts_state.dart';

class ContractsBloc extends Bloc<ContractsEvent, ContractsState> {
  final MainBloc mainBloc;
  bool initialDayFirst = true;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  List<String> monthNames = AppDateTime.monthNames;
  List<int> monthDays = AppDateTime.monthDays;

  bool contractButtonSelect = true;

  ScrollController invoiceController = ScrollController();
  ScrollController dayController = ScrollController();
  ScrollController dayController2 = ScrollController();
  bool dayControllerLeftDone = true;
  bool dayControllerRightDone = true;

  List<ContractModel> filterContracts = [];
  List<InvoiceModel> filterInvoices = [];
  bool filterEnabled = false;
  bool filterPaid = false;
  bool filterInProcess = false;
  bool filterIQ = false;
  bool filterPayme = false;
  bool filterInProcessOld = false;
  bool filterIQOld = false;
  bool filterPaidOld = false;
  bool filterPaymeOld = false;
  String selectedDateFilter = DateTime.now().toString().substring(0, 10);
  String selectedDateFilterTo = 'to'.tr();
  String selectedDateFilterOld = DateTime.now().toString().substring(0, 10);
  String selectedDateFilterToOld = 'to'.tr();

  ContractsBloc({required this.mainBloc})
      : super(ContractsInitialState(
          day: DateTime.now().day,
          month: DateTime.now().month,
          contractButtonSelect: true,
          filterContracts: const [],
          filterInvoices: const [],
        )) {
    on<InitialDayControllerEvent>(initialDayButtonController);
    on<InitialDay2ControllerEvent>(initialDay2ButtonController);
    on<ListenEvent>(listenDayButtonsController);
    on<FilterEvent>(pressFilter);
    on<SearchEvent>(pressSearch);
    on<MonthButtonEvent>(pressMonthButton);
    on<DayButtonEvent>(pressDayButton);
    on<OnReorderEvent>(onReorder);
    on<ContractOrInvoiceEvent>(pressContractOrInvoiceButton);
    on<SinglePageEvent>(pushSinglePage);
    on<ShowDatePickerEvent>(pressDatePicker);
    on<CancelFilterEvent>(pressCancelFilter);
    on<ApplyFilterEvent>(pressApplyFilter);
    on<StatusFilterEvent>(pressStatusFilter);
  }

  Future<void> initialDayButtonController(InitialDayControllerEvent event, Emitter<ContractsState> emit) async {
    if (initialDayFirst) {
      initialDayFirst = false;
      int currentMonthDayMax = AppDateTime.monthDays[DateTime.now().month - 1] == 28 && DateTime.now().year == 2024
          ? 29
          : AppDateTime.monthDays[DateTime.now().month - 1];

      double position = currentMonthDayMax - selectedDay < event.width ~/ 62
          ? ((currentMonthDayMax - (event.width ~/ 62)).toDouble()) * 62 - event.width % 62
          : (selectedDay.toDouble() - 1) * 62;
      dayController.animateTo(position, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);

      String? json = await DBService.loadData(StorageKey.user);
      mainBloc.userModel = userFromJson(json!);
    }
  }

  void initialDay2ButtonController(InitialDay2ControllerEvent event, Emitter<ContractsState> emit) {
    dayController2.jumpTo(event.position);
  }

  Future<void> pressContractOrInvoiceButton(ContractOrInvoiceEvent event, Emitter<ContractsState> emit) async {
    emit(ContractsLoadingState());
    if (event.first) {
      mainBloc.add(MainHideBottomNavigationBarEvent());
      mainBloc.contracts = await RTDBService.loadContracts(mainBloc.userModel.uId!);
      mainBloc.historyContracts = mainBloc.contracts.where((e) => e.deleted == true).toList();
      mainBloc.contracts.removeWhere((contract) => mainBloc.historyContracts.contains(contract));
      mainBloc.historyContracts = mainBloc.historyContracts.reversed.toList();
      mainBloc.contracts = mainBloc.contracts.reversed.toList();
      mainBloc.invoices = await RTDBService.loadInvoices(mainBloc.userModel.uId!);
      mainBloc.historyInvoices = mainBloc.invoices.where((e) => e.deleted == true).toList();
      mainBloc.invoices.removeWhere((invoice) => mainBloc.historyInvoices.contains(invoice));
      mainBloc.historyInvoices = mainBloc.historyInvoices.reversed.toList();
      mainBloc.invoices = mainBloc.invoices.reversed.toList();
      mainBloc.savedModel = await RTDBService.loadSaved(mainBloc.userModel.uId!);
      if (mainBloc.savedModel.savedContracts != null && mainBloc.savedModel.savedContracts!.isNotEmpty) {
        for (String key in mainBloc.savedModel.savedContracts!) {
          for (ContractModel model in mainBloc.contracts) {
            if (key == model.key) {
              mainBloc.savedContracts.add(model);
              break;
            }
          }
        }
      }
      if (mainBloc.savedModel.savedInvoices != null && mainBloc.savedModel.savedInvoices!.isNotEmpty) {
        for (String key in mainBloc.savedModel.savedInvoices!) {
          for (InvoiceModel model in mainBloc.invoices) {
            if (key == model.key) {
              mainBloc.savedInvoices.add(model);
              break;
            }
          }
        }
      }

      String? json = await DBService.loadData(StorageKey.history);
      if (json != null) {
        for (String s in historyModelFromJson(json).history) {
          for (ContractModel model in mainBloc.contracts) {
            if (model.key == s) {
              mainBloc.historyListContracts.add(model);
              break;
            }
          }
        }
        for (String s in historyModelFromJson(json).savedHistory) {
          for (ContractModel model in mainBloc.contracts) {
            if (model.key == s) {
              mainBloc.historyListSavedContracts.add(model);
              break;
            }
          }
        }
        for (String s in historyModelFromJson(json).historyHistory) {
          for (ContractModel model in mainBloc.historyContracts) {
            if (model.key == s) {
              mainBloc.historyListHistoryContracts.add(model);
              break;
            }
          }
        }
      }
      mainBloc.filterContracts =
          LogicService.filterContractList(day: selectedDay, month: selectedMonth, year: selectedYear, list: mainBloc.contracts);
      mainBloc.filterInvoices =
          LogicService.filterInvoiceList(day: selectedDay, month: selectedMonth, year: selectedYear, list: mainBloc.invoices);
      mainBloc.add(MainLanguageEvent());
      String? featureJson = await DBService.loadData(StorageKey.feature);
      if (featureJson == null || jsonDecode(featureJson)) {
        if (event.context.mounted) {
            FeatureDiscovery.discoverFeatures(
              event.context,
              <String>{'feature1', 'feature2', 'feature3', 'feature4', 'feature5'},
            );
          }
        if (event.context.mounted) {
            await FeatureDiscovery.clearPreferences(
              event.context,
              <String>{'feature1', 'feature2', 'feature3', 'feature4', 'feature5'},
            );
          }
        await DBService.saveFeature(false);
      }
    } else {
      contractButtonSelect = event.contract;
      if (event.network) {
        if (contractButtonSelect) {
          mainBloc.contracts = await RTDBService.loadContracts(mainBloc.userModel.uId!);
          mainBloc.contracts.removeWhere((contract) => mainBloc.historyContracts.contains(contract));
          mainBloc.contracts = mainBloc.contracts.reversed.toList();
          mainBloc.filterContracts =
              LogicService.filterContractList(day: selectedDay, month: selectedMonth, year: selectedYear, list: mainBloc.contracts);

          if (filterEnabled) {
            filterContracts = [];
            for (ContractModel model in mainBloc.contracts) {
              if (LogicService.compareDate(selectedDateFilter, selectedDateFilterTo, model.createdDate!) &&
                  LogicService.compareStatus(
                    filterInProcess: filterInProcess,
                    filterIQ: filterIQ,
                    filterPaid: filterPaid,
                    filterPayme: filterPayme,
                    status: model.status!,
                  )) {
                filterContracts.add(model);
              }
            }
          }
        } else {
          mainBloc.invoices = await RTDBService.loadInvoices(mainBloc.userModel.uId!);
          mainBloc.invoices.removeWhere((invoice) => mainBloc.historyInvoices.contains(invoice));
          mainBloc.invoices = mainBloc.invoices.reversed.toList();
          mainBloc.filterInvoices = LogicService.filterInvoiceList(
            day: selectedDay,
            month: selectedMonth,
            year: selectedYear,
            list: mainBloc.invoices,
          );
        }
        if (filterEnabled) {
          filterInvoices = [];
          for (InvoiceModel model in mainBloc.invoices) {
            if (LogicService.compareDate(selectedDateFilter, selectedDateFilterTo, model.createdDate!) &&
                LogicService.compareStatus(
                  filterInProcess: filterInProcess,
                  filterIQ: filterIQ,
                  filterPaid: filterPaid,
                  filterPayme: filterPayme,
                  status: model.status!,
                )) {
              filterInvoices.add(model);
            }
          }
        }
      }
    }

    emit(ContractsInitialState(
      month: selectedMonth,
      day: selectedDay,
      contractButtonSelect: contractButtonSelect,
      filterContracts: mainBloc.filterContracts,
      filterInvoices: mainBloc.filterInvoices,
    ));
  }

  void pressFilter(FilterEvent event, Emitter<ContractsState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    if (selectedDateFilterTo == 'To' ||
        selectedDateFilterTo == 'Gacha' ||
        selectedDateFilterTo == 'До') {
      selectedDateFilterTo = 'to'.tr();
    }
    emit(ContractsFilterState(
      selectedDateFilter: selectedDateFilter,
      selectedDateFilterTo: selectedDateFilterTo,
      paid: filterPaid,
      inProcess: filterInProcess,
      rejectedPayme: filterPayme,
      rejectedIQ: filterIQ,
    ));
  }

  void pressSearch(SearchEvent event, Emitter<ContractsState> emit) {
    showSearch(
      context: event.context,
      delegate: MySearchDelegate(
        mainBloc: mainBloc,
        pressSearchElement: ({required int index}) => add(SinglePageEvent(index: index, context: event.context, search: true)),
      ),
    );
  }

  void pressMonthButton(MonthButtonEvent event, Emitter<ContractsState> emit) {
    if (event.left) {
      if (selectedMonth == 1) {
        selectedMonth = 12;
        selectedYear--;
      } else {
        selectedMonth--;
      }
      selectedDay = monthDays[selectedMonth - 1] == 28 && selectedYear == 2024 ? 29 : monthDays[selectedMonth - 1];
      dayController.jumpTo(selectedDay * 62 - event.width);
    } else {
      if (selectedMonth == 12) {
        selectedMonth = 1;
        selectedYear++;
      } else {
        selectedMonth++;
      }
      selectedDay = 1;
      dayController.jumpTo(0);
    }
    mainBloc.selectedDay = selectedDay;
    mainBloc.selectedMonth = selectedMonth;
    mainBloc.selectedYear = selectedYear;
    mainBloc.dayControllerPixels = dayController.position.pixels;

    emit(ContractsInitialState(
      month: selectedMonth,
      day: selectedDay,
      contractButtonSelect: contractButtonSelect,
      filterContracts: mainBloc.filterContracts,
      filterInvoices: mainBloc.filterInvoices,
    ));
  }

  void pressDayButton(DayButtonEvent event, Emitter<ContractsState> emit) {
    selectedDay = event.selectedDay;
    mainBloc.selectedDay = selectedDay;
    mainBloc.filterContracts = LogicService.filterContractList(
      day: selectedDay,
      month: selectedMonth,
      year: selectedYear,
      list: mainBloc.contracts,
    );
    mainBloc.filterInvoices = LogicService.filterInvoiceList(
      day: selectedDay,
      month: selectedMonth,
      year: selectedYear,
      list: mainBloc.invoices,
    );

    emit(ContractsInitialState(
      month: selectedMonth,
      day: selectedDay,
      contractButtonSelect: contractButtonSelect,
      filterContracts: mainBloc.filterContracts,
      filterInvoices: mainBloc.filterInvoices,
    ));
  }

  void listenDayButtonsController(ListenEvent event, Emitter<ContractsState> emit) async {
    if (dayController.position.pixels >= 0) {
      dayControllerLeftDone = true;
    }
    if (dayController.position.pixels <= monthDays[selectedMonth - 1] * 62) {
      dayControllerRightDone = true;
    }

    if (dayController.position.pixels < -110 && dayControllerLeftDone) {
      dayControllerLeftDone = false;
      if (selectedMonth == 1) {
        selectedMonth = 12;
        selectedYear--;
      } else {
        selectedMonth--;
      }
      selectedDay = monthDays[selectedMonth - 1] == 28 && selectedYear == 2024 ? 29 : monthDays[selectedMonth - 1];
      emit(ContractsInitialState(
        month: selectedMonth,
        day: selectedDay,
        contractButtonSelect: contractButtonSelect,
        filterContracts: mainBloc.filterContracts,
        filterInvoices: mainBloc.filterInvoices,
      ));
      dayController.jumpTo((selectedDay) * 62 + 109 - event.width);
    }

    if (dayControllerRightDone &&
        dayController.position.pixels >
            ((monthDays[selectedMonth - 1] == 28 && selectedYear == 2024)
                ? 29 * 62 + 110 - event.width
                : monthDays[selectedMonth - 1] * 62 + 110 - event.width)) {
      dayControllerRightDone = false;
      if (selectedMonth == 12) {
        selectedMonth = 1;
        selectedYear++;
      } else {
        selectedMonth++;
      }
      selectedDay = 1;
      emit(ContractsInitialState(
        month: selectedMonth,
        day: selectedDay,
        contractButtonSelect: contractButtonSelect,
        filterContracts: mainBloc.filterContracts,
        filterInvoices: mainBloc.filterInvoices,
      ));
      dayController.jumpTo(-109);
    }
    mainBloc.selectedDay = selectedDay;
    mainBloc.selectedMonth = selectedMonth;
    mainBloc.selectedYear = selectedYear;
    mainBloc.dayControllerPixels = dayController.position.pixels;
    mainBloc.filterContracts =
        LogicService.filterContractList(day: selectedDay, month: selectedMonth, year: selectedYear, list: mainBloc.contracts);
    mainBloc.filterInvoices =
        LogicService.filterInvoiceList(day: selectedDay, month: selectedMonth, year: selectedYear, list: mainBloc.invoices);
  }

  void onReorder(OnReorderEvent event, Emitter<ContractsState> emit) {
    final newIdx = event.newIndex > event.oldIndex ? event.newIndex - 1 : event.newIndex;
    if (contractButtonSelect) {
      if (filterEnabled) {
        final item = filterContracts.removeAt(event.oldIndex);
        filterContracts.insert(newIdx, item);
      } else {
        final item = mainBloc.filterContracts.removeAt(event.oldIndex);
        mainBloc.filterContracts.insert(newIdx, item);
      }
    } else {
      if (filterEnabled) {
        final item = filterInvoices.removeAt(event.oldIndex);
        filterInvoices.insert(newIdx, item);
      } else {
        final item = mainBloc.filterInvoices.removeAt(event.oldIndex);
        mainBloc.filterInvoices.insert(newIdx, item);
      }
    }

    emit(ContractsInitialState(
      month: selectedMonth,
      day: selectedDay,
      contractButtonSelect: contractButtonSelect,
      filterContracts: mainBloc.filterContracts,
      filterInvoices: mainBloc.filterInvoices,
    ));
  }

  void pushSinglePage(SinglePageEvent event, Emitter<ContractsState> emit) async {
    if (event.search) {
      final item = mainBloc.suggestions.toList()[event.index];
      mainBloc.historyListContracts.remove(item);
      mainBloc.historyListContracts.insert(0, item);
      mainBloc.historyModel.history.remove(item.key!);
      mainBloc.historyModel.history.insert(0, item.key!);
      await DBService.saveHistory(mainBloc.historyModel);
      if (event.context.mounted) {
        Navigator.push(
            event.context,
            MaterialPageRoute(
              builder: (context) => SinglePage(
                isContract: true,
                contractModel: item,
                contracts: mainBloc.contracts.where((model) => (model.fullName == item.fullName) && (model.number != item.number)).toList(),
                mainBloc: mainBloc,
              ),
            ));
      }
    } else {
      if (contractButtonSelect) {
        ContractModel item = filterEnabled ? filterContracts[event.index] : mainBloc.filterContracts[event.index];
        ContractModel? model = await Navigator.push(
            event.context,
            MaterialPageRoute(
              builder: (context) => SinglePage(
                isContract: true,
                contractModel: item,
                contracts: mainBloc.contracts.where((model) => (model.fullName == item.fullName) && (model.number != item.number)).toList(),
                mainBloc: mainBloc,
              ),
            ));
        if (model != null && event.context.mounted) {
          if (filterEnabled) {
            add(ApplyFilterEvent(context: event.context));
          } else {
            emit(ContractsInitialState(
              month: selectedMonth,
              day: selectedDay,
              contractButtonSelect: contractButtonSelect,
              filterContracts: mainBloc.filterContracts,
              filterInvoices: mainBloc.filterInvoices,
            ));
          }
        }
      } else {
        InvoiceModel item = filterEnabled ? filterInvoices[event.index] : mainBloc.filterInvoices[event.index];
        InvoiceModel? model = await Navigator.push(
          event.context,
          MaterialPageRoute(
            builder: (context) => SinglePage(
              isContract: false,
              invoiceModel: item,
              invoices: mainBloc.invoices.where((model) => (model.fullName == item.fullName) && (model.number != item.number)).toList(),
              mainBloc: mainBloc,
            ),
          ),
        );
        if (model != null && event.context.mounted) {
          if (filterEnabled) {
            add(ApplyFilterEvent(context: event.context));
          } else {
            emit(ContractsInitialState(
              month: selectedMonth,
              day: selectedDay,
              contractButtonSelect: contractButtonSelect,
              filterContracts: mainBloc.filterContracts,
              filterInvoices: mainBloc.filterInvoices,
            ));
          }
        }
      }
    }
  }

  void pressCancelFilter(CancelFilterEvent event, Emitter<ContractsState> emit) async {
    if (event.remove) {
      filterEnabled = false;
      filterInProcess = false;
      filterIQ = false;
      filterPaid = false;
      filterPayme = false;
      filterInProcessOld = false;
      filterIQOld = false;
      filterPaidOld = false;
      filterPaymeOld = false;
      selectedDateFilterTo = 'to'.tr();
      selectedDateFilterToOld = 'to'.tr();
      selectedDateFilter = DateTime.now().toString().substring(0, 10);
      selectedDateFilterOld = selectedDateFilter;
      filterContracts = [];
      emit(ContractsInitialState(
        month: selectedMonth,
        day: selectedDay,
        contractButtonSelect: contractButtonSelect,
        filterContracts: mainBloc.filterContracts,
        filterInvoices: mainBloc.filterInvoices,
      ));
      int currentMonthDayMax = AppDateTime.monthDays[DateTime.now().month - 1] == 28 && DateTime.now().year == 2024
          ? 29
          : AppDateTime.monthDays[DateTime.now().month - 1];

      double position = currentMonthDayMax - selectedDay < event.width ~/ 62
          ? ((currentMonthDayMax - (event.width ~/ 62)).toDouble()) * 62 - event.width % 62
          : (selectedDay.toDouble() - 1) * 62;
      await Future.delayed(const Duration(milliseconds: 10));
      dayController.animateTo(position, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    } else {
      filterInProcess = filterInProcessOld;
      filterIQ = filterIQOld;
      filterPaid = filterPaidOld;
      filterPayme = filterPaymeOld;
      selectedDateFilter = selectedDateFilterOld;
      selectedDateFilterTo = selectedDateFilterToOld;
      emit(ContractsInitialState(
        month: selectedMonth,
        day: selectedDay,
        contractButtonSelect: contractButtonSelect,
        filterContracts: mainBloc.filterContracts,
        filterInvoices: mainBloc.filterInvoices,
      ));
    }
    mainBloc.add(MainLanguageEvent());
  }

  void pressApplyFilter(ApplyFilterEvent event, Emitter<ContractsState> emit) {
    if (selectedDateFilterTo == 'to'.tr()) {
      Utils.mySnackBar(txt: 'choose_time_frame'.tr(), context: event.context, errorState: true);
    } else if (filterPayme || filterPaid || filterInProcess || filterIQ) {
      filterInProcessOld = filterInProcess;
      filterIQOld = filterIQ;
      filterPaidOld = filterPaid;
      filterPaymeOld = filterPayme;
      selectedDateFilterOld = selectedDateFilter;
      selectedDateFilterToOld = selectedDateFilterTo;
      filterEnabled = true;
      filterContracts = [];
      for (ContractModel model in mainBloc.contracts) {
        if (LogicService.compareDate(selectedDateFilter, selectedDateFilterTo, model.createdDate!) &&
            LogicService.compareStatus(
              filterInProcess: filterInProcess,
              filterIQ: filterIQ,
              filterPaid: filterPaid,
              filterPayme: filterPayme,
              status: model.status!,
            )) {
          filterContracts.add(model);
        }
      }

      filterInvoices = [];
      for (InvoiceModel model in mainBloc.invoices) {
        if (LogicService.compareDate(selectedDateFilter, selectedDateFilterTo, model.createdDate!) &&
            LogicService.compareStatus(
              filterInProcess: filterInProcess,
              filterIQ: filterIQ,
              filterPaid: filterPaid,
              filterPayme: filterPayme,
              status: model.status!,
            )) {
          filterInvoices.add(model);
        }
      }

      emit(ContractsInitialState(
        month: selectedMonth,
        day: selectedDay,
        contractButtonSelect: contractButtonSelect,
        filterContracts: mainBloc.filterContracts,
        filterInvoices: mainBloc.filterInvoices,
      ));
      mainBloc.add(MainLanguageEvent());
    } else {
      Utils.mySnackBar(txt: 'set_status'.tr(), context: event.context, errorState: true);
    }
  }

  Future<void> pressDatePicker(ShowDatePickerEvent event, Emitter<ContractsState> emit) async {
    DateTime? picked;

    if (event.toDate) {
      picked = await showDatePicker(
          context: event.context,
          initialDate: selectedDateFilterTo != 'to'.tr() ? DateTime.parse(selectedDateFilterTo) : DateTime.now(),
          firstDate: DateTime.parse(selectedDateFilter),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return myDatePickerTheme(child);
          });
    } else {
      picked = await showDatePicker(
          context: event.context,
          initialDate: DateTime.parse(selectedDateFilter),
          firstDate: DateTime.parse(mainBloc.userModel.createdTime!),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return myDatePickerTheme(child);
          });
      if (picked != null) {
        selectedDateFilterTo = 'to'.tr();
      }
    }

    if (picked != null) {
      if (event.toDate) {
        selectedDateFilterTo = picked.toString().substring(0, 10);
      } else {
        selectedDateFilter = picked.toString().substring(0, 10);
      }
      emit(ContractsFilterState(
        selectedDateFilter: selectedDateFilter,
        selectedDateFilterTo: selectedDateFilterTo,
        paid: filterPaid,
        inProcess: filterInProcess,
        rejectedPayme: filterPayme,
        rejectedIQ: filterIQ,
      ));
    }
  }

  void pressStatusFilter(StatusFilterEvent event, Emitter<ContractsState> emit) {
    switch (event.status) {
      case StatusFilter.paid:
        {
          filterPaid = !filterPaid;
          break;
        }
      case StatusFilter.rejectedIQ:
        {
          filterIQ = !filterIQ;
          break;
        }
      case StatusFilter.rejectedPayme:
        {
          filterPayme = !filterPayme;
          break;
        }
      default:
        filterInProcess = !filterInProcess;
    }
    emit(ContractsFilterState(
      selectedDateFilter: selectedDateFilter,
      selectedDateFilterTo: selectedDateFilterTo,
      paid: filterPaid,
      inProcess: filterInProcess,
      rejectedPayme: filterPayme,
      rejectedIQ: filterIQ,
    ));
  }
}
