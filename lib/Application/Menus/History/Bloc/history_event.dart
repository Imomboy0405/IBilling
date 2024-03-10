part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
}

class InitialEvent extends HistoryEvent {
  @override
  List<Object?> get props => [];
}

class FilterEvent extends HistoryEvent {
  @override
  List<Object?> get props => [];
}

class SearchEvent extends HistoryEvent {
  final BuildContext context;

  const SearchEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class CancelFilterEvent extends HistoryEvent {
  final bool remove;

  const CancelFilterEvent({this.remove = false});

  @override
  List<Object?> get props => [remove];
}

class ApplyFilterEvent extends HistoryEvent {
  final BuildContext context;

  const ApplyFilterEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class StatusFilterEvent extends HistoryEvent {
  final StatusFilter status;

  const StatusFilterEvent({
    required this.status,
  });

  @override
  List<Object?> get props => [status];
}

class ShowDatePickerEvent extends HistoryEvent {
  final BuildContext context;
  final bool toDate;

  const ShowDatePickerEvent({required this.context, this.toDate = false});

  @override
  List<Object?> get props => [context, toDate];
}

class ContractOrInvoiceEvent extends HistoryEvent {
  final bool contract;

  const ContractOrInvoiceEvent({this.contract = false});

  @override
  List<Object?> get props => [contract];
}

class OnReorderEvent extends HistoryEvent {
  final int newIndex;
  final int oldIndex;

  const OnReorderEvent({required this.newIndex, required this.oldIndex});

  @override
  List<Object?> get props => [newIndex, oldIndex];

}

class SinglePageEvent extends HistoryEvent {
  final BuildContext context;
  final int index;
  final bool search;
  final bool filter;

  const SinglePageEvent({required this.context, required this.index, this.search = false, this.filter = false});

  @override
  List<Object?> get props => [context, index, filter];

}
