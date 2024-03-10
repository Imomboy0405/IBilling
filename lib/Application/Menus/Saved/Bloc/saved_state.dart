part of 'saved_bloc.dart';

abstract class SavedState extends Equatable {
  const SavedState();
}

class SavedInitialState extends SavedState {
  final List<ContractModel> savedContracts;
  final List<InvoiceModel> savedInvoices;
  final bool contractButtonSelect;

  const SavedInitialState({required this.savedContracts, required this.savedInvoices, required this.contractButtonSelect});

  @override
  List<Object> get props => [savedContracts, savedInvoices, contractButtonSelect];
}

class SavedLoadingState extends SavedState {
  @override
  List<Object> get props => [];
}

class SavedFilterState extends SavedState {
  final String selectedDateFilter;
  final String selectedDateFilterTo;
  final bool paid;
  final bool inProcess;
  final bool rejectedIQ;
  final bool rejectedPayme;

  const SavedFilterState({
    required this.selectedDateFilter,
    required this.selectedDateFilterTo,
    required this.paid,
    required this.inProcess,
    required this.rejectedIQ,
    required this.rejectedPayme,
  });

  @override
  List<Object> get props => [selectedDateFilter, selectedDateFilterTo, paid, inProcess, rejectedIQ, rejectedPayme];
}
