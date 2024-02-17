part of 'start_bloc.dart';

@immutable
abstract class StartEvent extends Equatable {}

class FlagEvent extends StartEvent {
  final BuildContext context;

  FlagEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class NextEvent extends StartEvent {
  final BuildContext context;

  NextEvent({required this.context});

  @override
  List<Object?> get props => [];
}

class SelectLanguageEvent extends StartEvent {
  final Language lang;

  SelectLanguageEvent({required this.lang});

  @override
  List<Object?> get props => [lang];

}
