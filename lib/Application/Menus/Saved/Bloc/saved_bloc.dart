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
import 'package:i_billing/Data/Service/r_t_d_b_service.dart';
import 'package:i_billing/Data/Service/util_service.dart';

part 'saved_event.dart';
part 'saved_state.dart';

class SavedBloc extends Bloc<SavedEvent, SavedState> {
  final MainBloc mainBloc;
  List<ContractModel> savedContracts = [];
  List<ContractModel> filterContracts = [];
  List<InvoiceModel> savedInvoices = [];
  List<InvoiceModel> filterInvoices = [];
  bool initial = true;
  bool contractButtonSelect = true;
  bool filterEnabled = false;
  bool singlePagePop = false;
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

  SavedBloc({required this.mainBloc})
      : super(
            SavedInitialState(savedContracts: mainBloc.savedContracts, contractButtonSelect: true, savedInvoices: mainBloc.savedInvoices)) {
    on<DeleteEvent>(deleting);
    on<SinglePageEvent>(pushSinglePage);
    on<InitialEvent>(initialSaved);
    on<CancelFilterEvent>(pressCancelFilter);
    on<ApplyFilterEvent>(pressApplyFilter);
    on<SearchEvent>(pressSearchButton);
    on<FilterEvent>(pressFilterButton);
    on<StatusFilterEvent>(pressStatusFilter);
    on<ShowDatePickerEvent>(pressDatePicker);
    on<ContractOrInvoiceEvent>(pressContractOrInvoiceButton);
    on<OnReorderEvent>(onReorder);
  }

  void pressFilterButton(FilterEvent event, Emitter<SavedState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    emit(SavedFilterState(
      selectedDateFilter: selectedDateFilter,
      selectedDateFilterTo: selectedDateFilterTo,
      paid: filterPaid,
      inProcess: filterInProcess,
      rejectedIQ: filterIQ,
      rejectedPayme: filterPayme,
    ));
  }

  void pressCancelFilter(CancelFilterEvent event, Emitter<SavedState> emit) {
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
    emit(SavedInitialState(savedContracts: savedContracts, savedInvoices: savedInvoices, contractButtonSelect: contractButtonSelect));
    mainBloc.add(MainLanguageEvent());
  }

  void pressApplyFilter(ApplyFilterEvent event, Emitter<SavedState> emit) {
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
      for (ContractModel model in savedContracts) {
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
      for (InvoiceModel model in savedInvoices) {
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
      emit(SavedInitialState(savedContracts: savedContracts, contractButtonSelect: contractButtonSelect, savedInvoices: savedInvoices));
      mainBloc.add(MainLanguageEvent());
    } else {
      Utils.mySnackBar(txt: 'set_status'.tr(), context: event.context, errorState: true);
    }
  }

  void pressStatusFilter(StatusFilterEvent event, Emitter<SavedState> emit) {
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
    emit(SavedFilterState(
      selectedDateFilter: selectedDateFilter,
      selectedDateFilterTo: selectedDateFilterTo,
      paid: filterPaid,
      inProcess: filterInProcess,
      rejectedIQ: filterIQ,
      rejectedPayme: filterPayme,
    ));
  }

  Future<void> pressDatePicker(ShowDatePickerEvent event, Emitter<SavedState> emit) async {
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

      emit(SavedFilterState(
        selectedDateFilter: selectedDateFilter,
        selectedDateFilterTo: selectedDateFilterTo,
        paid: filterPaid,
        inProcess: filterInProcess,
        rejectedIQ: filterIQ,
        rejectedPayme: filterPayme,
      ));
    }
  }

  void pressSearchButton(SearchEvent event, Emitter<SavedState> emit) {
    showSearch(
      context: event.context,
      delegate: MySearchDelegate(
        mainBloc: mainBloc,
        pressSearchElement: ({required int index}) => add(SinglePageEvent(index: index, context: event.context, search: true)),
        mySearch: MySearch.saved,
      ),
    );
  }

  void pressContractOrInvoiceButton(ContractOrInvoiceEvent event, Emitter<SavedState> emit) {
    contractButtonSelect = event.contract;
    emit(SavedInitialState(savedContracts: savedContracts, contractButtonSelect: contractButtonSelect, savedInvoices: savedInvoices));
  }

  void initialSaved(InitialEvent event, Emitter<SavedState> emit) {
    emit(SavedLoadingState());

    initial = false;
    singlePagePop = false;
    savedContracts = mainBloc.savedContracts;
    savedInvoices = mainBloc.savedInvoices;
    emit(SavedInitialState(savedContracts: savedContracts, contractButtonSelect: contractButtonSelect, savedInvoices: savedInvoices));
  }

  void deleting(DeleteEvent event, Emitter<SavedState> emit) async {
    emit(SavedLoadingState());

    if (contractButtonSelect) {
      mainBloc.savedContracts.remove(event.model);
      mainBloc.savedModel.savedContracts!.remove(event.model.key);
      savedContracts = mainBloc.savedContracts;
    } else {
      mainBloc.savedInvoices.remove(event.model);
      mainBloc.savedModel.savedInvoices!.remove(event.model.key);
      savedInvoices = mainBloc.savedInvoices;
    }
    await RTDBService.storeSaved(mainBloc.savedModel);

    emit(SavedInitialState(
        savedContracts: mainBloc.savedContracts, contractButtonSelect: contractButtonSelect, savedInvoices: savedInvoices));
  }

  void onReorder(OnReorderEvent event, Emitter<SavedState> emit) {
    final newIdx = event.newIndex > event.oldIndex ? event.newIndex - 1 : event.newIndex;
    if (contractButtonSelect) {
      if (filterEnabled) {
        final item = filterContracts.removeAt(event.oldIndex);
        filterContracts.insert(newIdx, item);
      } else {
        final item = savedContracts.removeAt(event.oldIndex);
        savedContracts.insert(newIdx, item);
      }
    } else {
      if (filterEnabled) {
        final item = filterInvoices.removeAt(event.oldIndex);
        filterInvoices.insert(newIdx, item);
      } else {
        final item = savedInvoices.removeAt(event.oldIndex);
        savedInvoices.insert(newIdx, item);
      }
    }

    emit(SavedInitialState(savedContracts: savedContracts, savedInvoices: savedInvoices, contractButtonSelect: contractButtonSelect));
  }

  Future<void> pushSinglePage(SinglePageEvent event, Emitter<SavedState> emit) async {
    emit(SavedInitialState(savedContracts: savedContracts, contractButtonSelect: contractButtonSelect, savedInvoices: savedInvoices));

    singlePagePop = true;
    if (event.search) {
      final item = mainBloc.suggestions.toList()[event.index];
      mainBloc.historyListSavedContracts.remove(item);
      mainBloc.historyListSavedContracts.insert(0, item);
      mainBloc.historyModel.savedHistory.remove(item.key!);
      mainBloc.historyModel.savedHistory.insert(0, item.key!);
      await DBService.saveHistory(mainBloc.historyModel);
      if (event.context.mounted) {
        await Navigator.push(
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
      await Navigator.push(
          event.context,
          MaterialPageRoute(
            builder: (context) => SinglePage(
              isContract: contractButtonSelect,
              contractModel: contractButtonSelect ? (event.filter ? filterContracts[event.index] : savedContracts[event.index]) : null,
              invoiceModel: !contractButtonSelect ? (event.filter ? filterInvoices[event.index] : savedInvoices[event.index]) : null,
              invoices: !contractButtonSelect
                  ? ((mainBloc.invoices
                      .where((model) =>
                          (event.filter ? filterInvoices[event.index].number : savedInvoices[event.index].number) != model.number)
                      .toList()))
                  : [],
              contracts: contractButtonSelect
                  ? (mainBloc.contracts
                      .where((model) =>
                          (model.fullName ==
                              (event.filter ? filterContracts[event.index].fullName : savedContracts[event.index].fullName)) &&
                          (model.number != (event.filter ? filterContracts[event.index].number : savedContracts[event.index].number)))
                      .toList())
                  : [],
              mainBloc: mainBloc,
            ),
          ));

      if (filterEnabled) {
        if (contractButtonSelect) {
          filterContracts = [];
          for (ContractModel model in savedContracts) {
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
        } else {
          filterInvoices = [];
          for (InvoiceModel model in savedInvoices) {
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
    emit(SavedLoadingState());
  }
}
