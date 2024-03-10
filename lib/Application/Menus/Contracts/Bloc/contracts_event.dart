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
  final BuildContext context;

  SearchEvent({required this.context});

  @override
  List<Object?> get props => [context];
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

class ContractOrInvoiceEvent extends ContractsEvent {
  final bool contract;
  final bool network;
  final bool first;
  final BuildContext context;

  ContractOrInvoiceEvent({this.contract = false, this.network = false, this.first = false, required this.context});

  @override
  List<Object?> get props => [contract, network, first, context];
}

class OnReorderEvent extends ContractsEvent {
  final int newIndex;
  final int oldIndex;

  OnReorderEvent({required this.newIndex, required this.oldIndex});

  @override
  List<Object?> get props => [newIndex, oldIndex];

}

class SinglePageEvent extends ContractsEvent {
  final int index;
  final BuildContext context;
  final bool search;

  SinglePageEvent({required this.index, required this.context, this.search = false});

  @override
  List<Object?> get props => [index, context, search];
}

class CancelFilterEvent extends ContractsEvent {
  final bool remove;
  final double width;

  CancelFilterEvent({this.remove = false, this.width = 0});

  @override
  List<Object?> get props => [remove, width];
}

class ApplyFilterEvent extends ContractsEvent {
  final BuildContext context;

  ApplyFilterEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class StatusFilterEvent extends ContractsEvent {
  final StatusFilter status;

  StatusFilterEvent({
    required this.status,
});

  @override
  List<Object?> get props => [status];

}

class ShowDatePickerEvent extends ContractsEvent {
  final BuildContext context;
  final bool toDate;

  ShowDatePickerEvent({required this.context, this.toDate = false});

  @override
  List<Object?> get props => [context, toDate];
}

class ClearHistoryEvent extends ContractsEvent {
  @override
  List<Object?> get props => [];
}

class ClearHistoryDoneEvent extends ContractsEvent {
  final bool cancel;

  ClearHistoryDoneEvent({this.cancel = false});

  @override
  List<Object?> get props => [cancel];
}

