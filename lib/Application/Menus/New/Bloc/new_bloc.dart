import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Data/Service/lang_service.dart';
import 'package:i_billing/Data/Service/logic_service.dart';

part 'new_event.dart';
part 'new_state.dart';

class NewBloc extends Bloc<NewEvent, NewState> {
  bool suffixServiceName = false;
  bool suffixInvoiceAmount = false;
  bool suffixFullName = false;
  bool suffixAddress = false;
  bool suffixTIN = false;
  String? status;
  String? face;
  List<String> statusList = <String>[
    'invoice_status_1'.tr(),
    'invoice_status_2'.tr(),
    'invoice_status_3'.tr(),
    'invoice_status_4'.tr(),
  ];
  List<String> faceStatusList = <String>[
    'face_status_1'.tr(),
    'face_status_2'.tr(),
  ];

  TextEditingController serviceNameController = TextEditingController();
  TextEditingController invoiceAmountController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController tINController = TextEditingController();

  FocusNode focusService = FocusNode();
  FocusNode focusInvoice = FocusNode();
  FocusNode focusStatus = FocusNode();
  FocusNode focusFace = FocusNode();
  FocusNode focusFullName = FocusNode();
  FocusNode focusAddress = FocusNode();
  FocusNode focusTIN = FocusNode();

  NewBloc() : super(NewInitialState()) {
    on<ContractEvent>(pressContractButton);
    on<InvoiceEvent>(pressInvoiceButton);
    on<InvoiceChange>(invoiceChange);
    on<InvoiceSubmitted>(invoiceSubmitted);
    on<InvoiceStatus>(selectedInvoiceStatus);
    on<InvoiceSave>(pressInvoiceSave);
    on<ContractChange>(contractChange);
    on<ContractSubmitted>(contractSubmitted);
    on<ContractStatus>(selectedContractStatus);
    on<ContractFaceStatus>(selectedFaceStatus);
    on<ContractSave>(pressContractSave);
  }

  void pressContractButton(ContractEvent event, Emitter<NewState> emit) {
    emit(NewContractState(
      face: null,
      status: null,
      suffixAddress: suffixAddress,
      suffixFullName: suffixFullName,
      suffixTIN: suffixTIN,
      borderAddress: false,
      borderFullName: false,
      borderTIN: false,
    ));
  }

  void pressInvoiceButton(InvoiceEvent event, Emitter<NewState> emit) {
    emit(NewInvoiceState(
      suffixServiceName: suffixServiceName,
      borderServiceName: false,
      suffixInvoiceAmount: suffixInvoiceAmount,
      borderInvoiceAmount: false,
      status: '',
    ));
  }

  void invoiceChange(InvoiceChange event, Emitter<NewState> emit) {
    suffixServiceName = serviceNameController.text.replaceAll(' ', '').length > 2;
    suffixInvoiceAmount = invoiceAmountController.text.replaceAll(' ', '').length > 8;

    emit(NewInvoiceState(
      suffixServiceName: suffixServiceName,
      borderServiceName: focusService.hasFocus || serviceNameController.text.isNotEmpty,
      suffixInvoiceAmount: suffixInvoiceAmount,
      borderInvoiceAmount: focusInvoice.hasFocus || invoiceAmountController.text.isNotEmpty,
      status: '',
    ));
  }

  Future<void> invoiceSubmitted(InvoiceSubmitted event, Emitter<NewState> emit) async {
    if (event.service) {
      focusService.unfocus();
      await Future.delayed(const Duration(milliseconds: 30));
      focusInvoice.requestFocus();
    } else {
      focusInvoice.unfocus();
      await Future.delayed(const Duration(milliseconds: 30));
      FocusScope.of(event.context!).requestFocus(focusStatus);
    }

    if (serviceNameController.text.isNotEmpty) {
      serviceNameController.text = serviceNameController.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    }
    suffixServiceName = serviceNameController.text.replaceAll(' ', '').length > 2;
    suffixInvoiceAmount = invoiceAmountController.text.replaceAll(' ', '').length > 8;

    emit(NewInvoiceState(
      suffixServiceName: suffixServiceName,
      borderServiceName: focusService.hasFocus || serviceNameController.text.isNotEmpty,
      suffixInvoiceAmount: suffixInvoiceAmount,
      borderInvoiceAmount: focusInvoice.hasFocus || invoiceAmountController.text.isNotEmpty,
      status: '',
    ));
  }

  void selectedInvoiceStatus(InvoiceStatus event, Emitter<NewState> emit) {
    status = event.status;
    emit(NewInvoiceState(
      suffixServiceName: suffixServiceName,
      borderServiceName: focusService.hasFocus || serviceNameController.text.isNotEmpty,
      suffixInvoiceAmount: suffixInvoiceAmount,
      borderInvoiceAmount: focusInvoice.hasFocus || invoiceAmountController.text.isNotEmpty,
      status: status,
    ));
  }

  void pressInvoiceSave(InvoiceSave event, Emitter<NewState> emit) {
    // todo code
  }

  void contractChange(ContractChange event, Emitter<NewState> emit) {
    suffixFullName = LogicService.checkFullName(fullNameController.text);
    suffixAddress = LogicService.checkFullName(addressController.text);
    suffixTIN = tINController.text.length == 11;

    emit(NewContractState(
      face: face,
      status: status,
      suffixAddress: suffixAddress,
      suffixFullName: suffixFullName,
      suffixTIN: suffixTIN,
      borderAddress: focusAddress.hasFocus || addressController.text.isNotEmpty,
      borderFullName: focusFullName.hasFocus || fullNameController.text.isNotEmpty,
      borderTIN: focusTIN.hasFocus || tINController.text.isNotEmpty,
    ));
  }

  Future<void> contractSubmitted(ContractSubmitted event, Emitter<NewState> emit) async {
    if (fullNameController.text.isNotEmpty) {
      fullNameController.text = fullNameController.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    }
    if (addressController.text.isNotEmpty) {
      addressController.text = addressController.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    }

    suffixFullName = LogicService.checkFullName(fullNameController.text);
    suffixAddress = LogicService.checkFullName(addressController.text);

    if (event.fullName){
      focusFullName.unfocus();
      await Future.delayed(const Duration(milliseconds: 30));
      focusAddress.requestFocus();
    } else if(event.address) {
        focusAddress.unfocus();
        await Future.delayed(const Duration(milliseconds: 30));
        focusTIN.requestFocus();
      } else {
        focusTIN.unfocus();
        await Future.delayed(const Duration(milliseconds: 30));
        focusStatus.requestFocus();
    }

    emit(NewContractState(
      face: face,
      status: status,
      suffixAddress: suffixAddress,
      suffixFullName: suffixFullName,
      suffixTIN: suffixTIN,
      borderAddress: addressController.text.trim().isNotEmpty,
      borderFullName: fullNameController.text.trim().isNotEmpty,
      borderTIN: tINController.text.trim().isNotEmpty,
    ));
  }

  void selectedFaceStatus(ContractFaceStatus event, Emitter<NewState> emit) {
    face = event.status;
    emit(NewContractState(
      face: face,
      status: status,
      suffixAddress: suffixAddress,
      suffixFullName: suffixFullName,
      suffixTIN: suffixTIN,
      borderAddress: focusAddress.hasFocus || addressController.text.isNotEmpty,
      borderFullName: focusFullName.hasFocus || fullNameController.text.isNotEmpty,
      borderTIN: focusTIN.hasFocus || tINController.text.isNotEmpty,
    ));
  }

  void selectedContractStatus(ContractStatus event, Emitter<NewState> emit) {
    status = event.status;
    emit(NewContractState(
      face: face,
      status: status,
      suffixAddress: suffixAddress,
      suffixFullName: suffixFullName,
      suffixTIN: suffixTIN,
      borderAddress: focusAddress.hasFocus || addressController.text.isNotEmpty,
      borderFullName: focusFullName.hasFocus || fullNameController.text.isNotEmpty,
      borderTIN: focusTIN.hasFocus || tINController.text.isNotEmpty,
    ));
  }

  void pressContractSave(ContractSave event, Emitter<NewState> emit) {
    // todo code
  }
}
