part of 'contracts_bloc.dart';

abstract class ContractsState extends Equatable {}

class ContractsInitialState extends ContractsState {
  final int day;
  final int month;
  final bool contractButtonSelect;
  final List<ContractModel> filterContracts;
  final List<InvoiceModel> filterInvoices;

  ContractsInitialState({
    required this.month,
    required this.day,
    required this.contractButtonSelect,
    required this.filterContracts,
    required this.filterInvoices,
  });

  @override
  List<Object> get props => [day, month, contractButtonSelect, filterContracts, filterInvoices];
}

class ContractsLoadingState extends ContractsState {
  @override
  List<Object> get props => [];
}

class ContractsFilterState extends ContractsState {
  final String selectedDateFilter;
  final String selectedDateFilterTo;
  final bool paid;
  final bool inProcess;
  final bool rejectedIQ;
  final bool rejectedPayme;

  ContractsFilterState({
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
