import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Data/Model/contract_model.dart';
import 'package:i_billing/Data/Model/invoice_model.dart';
import 'package:i_billing/Data/Model/saved_model.dart';
import 'package:i_billing/Data/Service/lang_service.dart';
import 'package:i_billing/Data/Service/r_t_d_b_service.dart';
import 'package:i_billing/Data/Service/util_service.dart';

part 'single_event.dart';
part 'single_state.dart';

class SingleBloc extends Bloc<SingleEvent, SingleState> {
  final MainBloc mainBloc;
  final bool isContract;
  bool save = false;
  bool history = false;
  bool initial = true;
  List<ContractModel> contracts;
  List<InvoiceModel> invoices = [];
  ContractModel contractModel;
  InvoiceModel invoiceModel;
  ScrollController controller = ScrollController();

  SingleBloc({
    required this.mainBloc,
    required this.isContract,
    required this.contractModel,
    required this.invoiceModel,
    this.contracts = const [],
    this.invoices = const [],
  }) : super(SingleInitialState(
          save: false,
          contractModel: contractModel,
          invoiceModel: invoiceModel,
          contracts: contracts,
          invoices: invoices,
        )) {
    on<SaveButtonEvent>(pressSaveButton);
    on<SinglePageEvent>(reBuildPage);
    on<DeleteButtonEvent>(pressDeleteButton);
    on<DeleteConfirmEvent>(pressDeleteConfirm);
    on<DeleteCancelEvent>(pressDeleteCancel);
    on<CreateButtonEvent>(pressCreateButton);
  }

  Future<void> pressSaveButton(SaveButtonEvent event, Emitter<SingleState> emit) async {
    if (history) {
      Utils.mySnackBar(txt: isContract ? 'contract_has_been_deleted'.tr() : 'invoice_has_been_deleted'.tr(), context: event.context, errorState: true);
    } else {
      emit(SingleLoadingState());

      if (event.initial) {
        initial = false;
        save = mainBloc.savedContracts.contains(contractModel);
        mainBloc.savedModel = SavedModel(
          uId: mainBloc.userModel.uId,
          savedContracts: mainBloc.savedContracts.map((e) => e.key!).toList(),
          savedInvoices: mainBloc.savedInvoices.map((e) => e.key!).toList(),
        );
      } else {
        if (isContract) {
          if (mainBloc.savedContracts.contains(contractModel)) {
            save = false;
            mainBloc.savedContracts.remove(contractModel);
            mainBloc.savedModel.savedContracts!.remove(contractModel.key!);
            await RTDBService.storeSaved(mainBloc.savedModel);
            mainBloc.add(MainLanguageEvent());
          } else {
            save = true;
            mainBloc.savedContracts.insert(0, contractModel);
            mainBloc.savedModel.savedContracts!.insert(0, contractModel.key!);
            await RTDBService.storeSaved(mainBloc.savedModel);
            mainBloc.add(MainLanguageEvent());
          }
        } else {
          if (mainBloc.savedInvoices.contains(invoiceModel)) {
            save = false;
            mainBloc.savedInvoices.remove(invoiceModel);
            mainBloc.savedModel.savedInvoices!.remove(invoiceModel.key!);
            await RTDBService.storeSaved(mainBloc.savedModel);
            mainBloc.add(MainLanguageEvent());
          } else {
            save = true;
            mainBloc.savedInvoices.insert(0, invoiceModel);
            mainBloc.savedModel.savedInvoices!.insert(0, invoiceModel.key!);
            await RTDBService.storeSaved(mainBloc.savedModel);
            mainBloc.add(MainLanguageEvent());
          }
        }
      }

      emit(SingleInitialState(
        save: save,
        contractModel: contractModel,
        contracts: contracts,
        invoiceModel: invoiceModel,
        invoices: invoices,
      ));
    }
  }

  Future<void> pressDeleteButton(DeleteButtonEvent event, Emitter<SingleState> emit) async {
    emit(SingleDeleteState());
  }

  void reBuildPage(SinglePageEvent event, Emitter<SingleState> emit) {
    if (isContract) {
      contracts.add(contractModel);
      contractModel = contracts[event.index];
      contracts.remove(contracts[event.index]);
    } else {
      invoices.add(invoiceModel);
      invoiceModel = invoices[event.index];
      invoices.remove(invoices[event.index]);
    }
    controller.jumpTo(0);

    emit(SingleInitialState(
      save: save,
      contractModel: contractModel,
      contracts: contracts,
      invoiceModel: invoiceModel,
      invoices: invoices,
    ));
  }

  Future<void> pressDeleteCancel(DeleteCancelEvent event, Emitter<SingleState> emit) async {
    emit(SingleInitialState(save: save, contractModel: contractModel, contracts: contracts, invoiceModel: invoiceModel, invoices: invoices));
  }

  Future<void> pressDeleteConfirm(DeleteConfirmEvent event, Emitter<SingleState> emit) async {
    emit(SingleLoadingState());

    if (isContract) {
      try {
        ContractModel model = ContractModel.copy(contractModel);
        model.deleted = true;
        await RTDBService.storeContract(model);
        mainBloc.contracts.remove(contractModel);
        mainBloc.savedContracts.remove(contractModel);
        mainBloc.filterContracts.remove(contractModel);
        mainBloc.historyListSavedContracts.remove(contractModel);
        mainBloc.historyListContracts.remove(contractModel);
        mainBloc.historyContracts.insert(0, model);
        if (event.context.mounted) {
          Utils.mySnackBar(txt: 'deleting_complete'.tr(), context: event.context);
          Navigator.pop(event.context, contractModel);
        }
      } catch (e) {
        if (event.context.mounted) {
          Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
        }
      }
    } else {
      try {
        InvoiceModel model = InvoiceModel.copy(invoiceModel);
        model.deleted = true;
        await RTDBService.storeInvoice(model);
        mainBloc.invoices.remove(invoiceModel);
        mainBloc.savedInvoices.remove(invoiceModel);
        mainBloc.filterInvoices.remove(invoiceModel);
        mainBloc.historyInvoices.insert(0, model);
        // mainBloc.historyListHistoryContracts.remove(invoiceModel);
        // mainBloc.historyListContracts.remove(invoiceModel);
        if (event.context.mounted) {
          Utils.mySnackBar(txt: 'deleting_complete'.tr(), context: event.context);
          Navigator.pop(event.context, invoiceModel);
        }
      } catch (e) {
        if (event.context.mounted) {
          Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
        }
      }
    }
  }

  void pressCreateButton(CreateButtonEvent event, Emitter<SingleState> emit) {
    Navigator.pop(event.context);
    mainBloc.add(MainMenuButtonEvent(index: 2));
  }
}
