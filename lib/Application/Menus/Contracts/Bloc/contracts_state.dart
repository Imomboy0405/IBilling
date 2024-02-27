part of 'contracts_bloc.dart';

abstract class ContractsState extends Equatable {}

class ContractsInitialState extends ContractsState {
  final int day;
  final int month;

  ContractsInitialState({required this.month, required this.day});

  @override
  List<Object> get props => [day, month];
}
