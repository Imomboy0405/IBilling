part of 'new_bloc.dart';

abstract class NewEvent extends Equatable {}

class ContractEvent extends NewEvent {
  @override
  List<Object?> get props => [];
}

class InvoiceEvent extends NewEvent {
  @override
  List<Object?> get props => [];
}

class InvoiceChange extends NewEvent {
  @override
  List<Object?> get props => [];
}

class InvoiceSubmitted extends NewEvent {
  final bool service;
  final BuildContext? context;

  InvoiceSubmitted({this.service = false, this.context});

  @override
  List<Object?> get props => [service, context];
}

class InvoiceStatus extends NewEvent {
  final String status;

  InvoiceStatus({required this.status});

  @override
  List<Object?> get props => [status];
}

class InvoiceSave extends NewEvent {
  @override
  List<Object?> get props => [];
}

class ContractSave extends NewEvent {
  @override
  List<Object?> get props => [];
}

class ContractFaceStatus extends NewEvent {
  final String status;

  ContractFaceStatus({required this.status});

  @override
  List<Object?> get props => [status];
}

class ContractStatus extends NewEvent {
  final String status;

  ContractStatus({required this.status});

  @override
  List<Object?> get props => [status];
}

class ContractChange extends NewEvent {
  @override
  List<Object?> get props => [];
}

class ContractSubmitted extends NewEvent {
  final bool fullName;
  final bool address;
  final BuildContext? context;

  ContractSubmitted({this.fullName = false, this.address = false, this.context});

  @override
  List<Object?> get props => [fullName, context, address];
}