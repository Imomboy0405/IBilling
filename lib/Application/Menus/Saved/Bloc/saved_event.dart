part of 'saved_bloc.dart';

abstract class SavedEvent extends Equatable {
  const SavedEvent();
}

class DeleteEvent extends SavedEvent {
  final dynamic model;

  const DeleteEvent({required this.model});

  @override
  List<Object?> get props => [model];
}

class SinglePageEvent extends SavedEvent {
  final BuildContext context;
  final int index;
  final bool search;
  final bool filter;

  const SinglePageEvent({required this.context, required this.index, this.search = false, this.filter = false});

  @override
  List<Object?> get props => [context, index, filter];

}

class InitialEvent extends SavedEvent {
  @override
  List<Object?> get props => [];
}

class FilterEvent extends SavedEvent {
  @override
  List<Object?> get props => [];
}

class SearchEvent extends SavedEvent {
  final BuildContext context;

  const SearchEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class CancelFilterEvent extends SavedEvent {
  final bool remove;

  const CancelFilterEvent({this.remove = false});

  @override
  List<Object?> get props => [remove];
}

class ApplyFilterEvent extends SavedEvent {
  final BuildContext context;

  const ApplyFilterEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class StatusFilterEvent extends SavedEvent {
  final StatusFilter status;

  const StatusFilterEvent({
    required this.status,
  });

  @override
  List<Object?> get props => [status];
}

class ShowDatePickerEvent extends SavedEvent {
  final BuildContext context;
  final bool toDate;

  const ShowDatePickerEvent({required this.context, this.toDate = false});

  @override
  List<Object?> get props => [context, toDate];
}

class ContractOrInvoiceEvent extends SavedEvent {
  final bool contract;

  const ContractOrInvoiceEvent({this.contract = false});

  @override
  List<Object?> get props => [contract];
}

class OnReorderEvent extends SavedEvent {
  final int newIndex;
  final int oldIndex;

  const OnReorderEvent({required this.newIndex, required this.oldIndex});

  @override
  List<Object?> get props => [newIndex, oldIndex];

}

