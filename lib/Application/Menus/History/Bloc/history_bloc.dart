import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Application/Menus/View/Single/View/single_page.dart';
import 'package:i_billing/Application/Menus/View/menus_widgets.dart';
import 'package:i_billing/Data/Model/contract_model.dart';
import 'package:i_billing/Data/Model/invoice_model.dart';
import 'package:i_billing/Data/Service/db_service.dart';
import 'package:i_billing/Data/Service/lang_service.dart';
import 'package:i_billing/Data/Service/logic_service.dart';
import 'package:i_billing/Data/Service/util_service.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  MainBloc mainBloc;
  bool initial = true;
  bool contractButtonSelect = true;
  List<ContractModel> historyContracts = [];
  List<InvoiceModel> historyInvoices = [];

  List<ContractModel> filterContracts = [];
  List<InvoiceModel> filterInvoices = [];
  bool filterEnabled = false;
  bool filterInProcess = false;
  bool filterIQ = false;
  bool filterPaid = false;
  bool filterPayme = false;
  bool filterInProcessOld = false;
  bool filterIQOld = false;
  bool filterPaidOld = false;
  bool filterPaymeOld = false;
  String selectedDateFilter = DateTime.now().toString().substring(0, 10);
  String selectedDateFilterTo = 'to'.tr();
  String selectedDateFilterOld = DateTime.now().toString().substring(0, 10);
  String selectedDateFilterToOld = 'to'.tr();

  HistoryBloc({required this.mainBloc})
      : super(const HistoryInitialState(
          historyContracts: [],
          historyInvoices: [],
          contractButtonSelect: true,
        )) {
    on<InitialEvent>(initialHistory);
    on<CancelFilterEvent>(pressCancelFilter);
    on<ApplyFilterEvent>(pressApplyFilter);
    on<SearchEvent>(pressSearchButton);
    on<FilterEvent>(pressFilterButton);
    on<StatusFilterEvent>(pressStatusFilter);
    on<ShowDatePickerEvent>(pressDatePicker);
    on<OnReorderEvent>(onReorder);
    on<SinglePageEvent>(pushSinglePage);
    on<ContractOrInvoiceEvent>(pressContractOrInvoiceButton);
  }

  void initialHistory(InitialEvent event, Emitter<HistoryState> emit) {
    emit(HistoryLoadingState());

    initial = false;
    historyContracts = mainBloc.historyContracts;
    historyInvoices = mainBloc.historyInvoices;
    emit(HistoryInitialState(
      contractButtonSelect: contractButtonSelect,
      historyInvoices: historyInvoices,
      historyContracts: historyContracts,
    ));
  }

  void pressFilterButton(FilterEvent event, Emitter<HistoryState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    emit(HistoryFilterState(
      selectedDateFilter: selectedDateFilter,
      selectedDateFilterTo: selectedDateFilterTo,
      paid: filterPaid,
      inProcess: filterInProcess,
      rejectedIQ: filterIQ,
      rejectedPayme: filterPayme,
    ));
  }

  void pressCancelFilter(CancelFilterEvent event, Emitter<HistoryState> emit) {
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
      filterInvoices = [];
    } else {
      filterInProcess = filterInProcessOld;
      filterIQ = filterIQOld;
      filterPaid = filterPaidOld;
      filterPayme = filterPaymeOld;
      selectedDateFilter = selectedDateFilterOld;
      selectedDateFilterTo = selectedDateFilterToOld;
    }
    emit(HistoryInitialState(
      contractButtonSelect: contractButtonSelect,
      historyInvoices: historyInvoices,
      historyContracts: historyContracts,
    ));
    mainBloc.add(MainLanguageEvent());
  }

  void pressApplyFilter(ApplyFilterEvent event, Emitter<HistoryState> emit) {
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
      for (ContractModel model in historyContracts) {
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
      for (InvoiceModel model in historyInvoices) {
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
      emit(HistoryInitialState(
          contractButtonSelect: contractButtonSelect, historyInvoices: historyInvoices, historyContracts: historyContracts));
      mainBloc.add(MainLanguageEvent());
    } else {
      Utils.mySnackBar(txt: 'set_status'.tr(), context: event.context, errorState: true);
    }
  }

  void pressStatusFilter(StatusFilterEvent event, Emitter<HistoryState> emit) {
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
    emit(HistoryFilterState(
      selectedDateFilter: selectedDateFilter,
      selectedDateFilterTo: selectedDateFilterTo,
      paid: filterPaid,
      inProcess: filterInProcess,
      rejectedIQ: filterIQ,
      rejectedPayme: filterPayme,
    ));
  }

  Future<void> pressDatePicker(ShowDatePickerEvent event, Emitter<HistoryState> emit) async {
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

      emit(HistoryFilterState(
        selectedDateFilter: selectedDateFilter,
        selectedDateFilterTo: selectedDateFilterTo,
        paid: filterPaid,
        inProcess: filterInProcess,
        rejectedIQ: filterIQ,
        rejectedPayme: filterPayme,
      ));
    }
  }

  void pressSearchButton(SearchEvent event, Emitter<HistoryState> emit) {
    showSearch(
      context: event.context,
      delegate: MySearchDelegate(
        mainBloc: mainBloc,
        pressSearchElement: ({required int index}) => add(SinglePageEvent(index: index, context: event.context, search: true)),
        mySearch: MySearch.history,
      ),
    );
  }

  void pressContractOrInvoiceButton(ContractOrInvoiceEvent event, Emitter<HistoryState> emit) {
    contractButtonSelect = event.contract;
    emit(HistoryInitialState(
      contractButtonSelect: contractButtonSelect,
      historyInvoices: historyInvoices,
      historyContracts: historyContracts,
    ));
  }

  void onReorder(OnReorderEvent event, Emitter<HistoryState> emit) {
    final newIdx = event.newIndex > event.oldIndex ? event.newIndex - 1 : event.newIndex;
    if (contractButtonSelect) {
      if (filterEnabled) {
        final item = filterContracts.removeAt(event.oldIndex);
        filterContracts.insert(newIdx, item);
      } else {
        final item = historyContracts.removeAt(event.oldIndex);
        historyContracts.insert(newIdx, item);
      }
    } else {
      if (filterEnabled) {
        final item = filterInvoices.removeAt(event.oldIndex);
        filterInvoices.insert(newIdx, item);
      } else {
        final item = historyInvoices.removeAt(event.oldIndex);
        historyInvoices.insert(newIdx, item);
      }
    }

    emit(HistoryInitialState(
        contractButtonSelect: contractButtonSelect, historyInvoices: historyInvoices, historyContracts: historyContracts));
  }

  Future<void> pushSinglePage(SinglePageEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryInitialState(
      contractButtonSelect: contractButtonSelect,
      historyInvoices: historyInvoices,
      historyContracts: historyContracts,
    ));

    if (event.search) {
      final item = mainBloc.suggestions.toList()[event.index];
      mainBloc.historyListHistoryContracts.remove(item);
      mainBloc.historyListHistoryContracts.insert(0, item);
      mainBloc.historyModel.historyHistory.remove(item.key!);
      mainBloc.historyModel.historyHistory.insert(0, item.key!);
      await DBService.saveHistory(mainBloc.historyModel);
      if (event.context.mounted) {
        await Navigator.push(
            event.context,
            MaterialPageRoute(
              builder: (context) => SinglePage(
                history: true,
                isContract: true,
                contractModel: item,
                contracts: mainBloc.contracts.where((model) => (model.fullName == item.fullName) && (model.number != item.number)).toList(),
                mainBloc: mainBloc,
              ),
            ));
      }
    } else {
      await Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => SinglePage(
            history: true,
            isContract: contractButtonSelect,
            contractModel: contractButtonSelect ? (event.filter ? filterContracts[event.index] : historyContracts[event.index]) : null,
            invoiceModel: !contractButtonSelect ? (event.filter ? filterInvoices[event.index] : historyInvoices[event.index]) : null,
            invoices: !contractButtonSelect
                ? ((historyInvoices
                    .where((model) =>
                        (event.filter ? filterInvoices[event.index].number : historyInvoices[event.index].number) != model.number)
                    .toList()))
                : [],
            contracts: contractButtonSelect
                ? (historyContracts
                    .where((model) =>
                        (model.fullName ==
                            (event.filter ? filterContracts[event.index].fullName : historyContracts[event.index].fullName)) &&
                        (model.number != (event.filter ? filterContracts[event.index].number : historyContracts[event.index].number)))
                    .toList())
                : [],
            mainBloc: mainBloc,
          ),
        ),
      );
    }
  }
}
