part of 'single_bloc.dart';

abstract class SingleEvent extends Equatable {
  const SingleEvent();
}

class SaveButtonEvent extends SingleEvent {
  final bool initial;
  final BuildContext context;

  const SaveButtonEvent({this.initial = false, required this.context});

  @override
  List<Object?> get props => [initial, context];
}

class SinglePageEvent extends SingleEvent {
  final int index;
  final bool initial;

  const SinglePageEvent({required this.index, this.initial = false});

  @override
  List<Object?> get props => [initial, index];
}

class DeleteButtonEvent extends SingleEvent {

  @override
  List<Object?> get props => [];
}

class DeleteConfirmEvent extends SingleEvent {
  final BuildContext context;

  const DeleteConfirmEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class DeleteCancelEvent extends SingleEvent {
  @override
  List<Object?> get props => [];
}

class CreateButtonEvent extends SingleEvent {
  final BuildContext context;

  const CreateButtonEvent({required this.context});

  @override
  List<Object?> get props => [context];
}