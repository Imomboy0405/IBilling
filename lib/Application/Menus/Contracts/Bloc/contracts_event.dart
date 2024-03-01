part of 'contracts_bloc.dart';

abstract class ContractsEvent extends Equatable {}

class DayButtonEvent extends ContractsEvent {
  final int selectedDay;

  DayButtonEvent({required this.selectedDay});

  @override
  List<Object?> get props => [selectedDay];

}

class MonthButtonEvent extends ContractsEvent {
  final bool left;
  final double width;

  MonthButtonEvent({this.left = false, this.width = 1});

  @override
  List<Object?> get props => [left, width];
}

class FilterEvent extends ContractsEvent {
  @override
  List<Object?> get props => [];
}

class SearchEvent extends ContractsEvent {
  @override
  List<Object?> get props => [];
}

class ListenEvent extends ContractsEvent {
  final double width;

  ListenEvent({required this.width});

  @override
  List<Object?> get props => [width];
}

class InitialDayControllerEvent extends ContractsEvent {
  final double width;

  InitialDayControllerEvent({required this.width});

  @override
  List<Object?> get props => [width];
}

class InitialDay2ControllerEvent extends ContractsEvent {
  final double position;

  InitialDay2ControllerEvent({required this.position});
  @override
  List<Object?> get props => [position];
}

class GetInvoicesEvent extends ContractsEvent {
  @override
  List<Object?> get props => [];
}

class OnReorderEvent extends ContractsEvent {
  final int newIndex;
  final int oldIndex;

  OnReorderEvent({required this.newIndex, required this.oldIndex});

  @override
  List<Object?> get props => [newIndex, oldIndex];

}


