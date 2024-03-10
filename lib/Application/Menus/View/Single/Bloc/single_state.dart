part of 'single_bloc.dart';

abstract class SingleState extends Equatable {
  const SingleState();
}

class SingleInitialState extends SingleState {
  final bool save;
  final ContractModel contractModel;
  final List<ContractModel> contracts;
  final InvoiceModel invoiceModel;
  final List<InvoiceModel> invoices;

  const SingleInitialState({
    required this.save,
    required this.contractModel,
    required this.contracts,
    required this.invoiceModel,
    required this.invoices,
  });

  @override
  List<Object> get props => [save, contractModel, contracts, invoiceModel, invoices];
}

class SingleLoadingState extends SingleState {
  @override
  List<Object> get props => [];
}

class SingleDeleteState extends SingleState {
  @override
  List<Object> get props => [];
}
