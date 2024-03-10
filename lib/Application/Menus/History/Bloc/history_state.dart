part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
}

class HistoryInitialState extends HistoryState {
  final bool contractButtonSelect;
  final List<ContractModel> historyContracts;
  final List<InvoiceModel> historyInvoices;

  const HistoryInitialState({
    required this.contractButtonSelect,
    required this.historyInvoices,
    required this.historyContracts,
});

  @override
  List<Object> get props => [historyInvoices, historyContracts, contractButtonSelect];
}

class HistoryFilterState extends HistoryState {
  final String selectedDateFilter;
  final String selectedDateFilterTo;
  final bool paid;
  final bool inProcess;
  final bool rejectedIQ;
  final bool rejectedPayme;

  const HistoryFilterState({
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

class HistoryLoadingState extends HistoryState {
  @override
  List<Object> get props => [];
}
