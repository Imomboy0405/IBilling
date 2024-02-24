part of 'new_bloc.dart';

abstract class NewState extends Equatable {}

class NewInitialState extends NewState {
  @override
  List<Object> get props => [];
}

class NewLoadingState extends NewState {
  @override
  List<Object> get props => [];
}

class NewContractState extends NewState {
  final bool suffixFullName;
  final bool suffixAddress;
  final bool suffixTIN;
  final bool borderFullName;
  final bool borderAddress;
  final bool borderTIN;
  final String? status;
  final String? face;

  NewContractState({
  required this.suffixFullName,
  required this.suffixAddress,
  required this.suffixTIN,
  required this.borderFullName,
  required this.borderAddress,
  required this.borderTIN,
  this.status,
  this.face,
});

  @override
  List<Object> get props => [
    suffixFullName,
    suffixAddress,
    suffixTIN,
    borderFullName,
    borderAddress,
    borderTIN,
    if(status != null) status!,
    if(face != null) face!,
  ];
}

class NewInvoiceState extends NewState {
  final bool suffixServiceName;
  final bool borderServiceName;
  final bool suffixInvoiceAmount;
  final bool borderInvoiceAmount;
  final String? status;

  NewInvoiceState({
    required this.suffixServiceName,
    required this.borderServiceName,
    required this.suffixInvoiceAmount,
    required this.borderInvoiceAmount,
    required this.status,
  });

  @override
  List<Object> get props => [
    suffixServiceName,
    borderServiceName,
    suffixInvoiceAmount,
    borderInvoiceAmount,
    status!,
  ];
}
