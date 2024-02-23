part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {}

class LanguageEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class SelectLanguageEvent extends ProfileEvent {
  final Language lang;

  SelectLanguageEvent({required this.lang});

  @override
  List<Object?> get props => [lang];
}

class CancelEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class DoneEvent extends ProfileEvent {
  final BuildContext context;

  DoneEvent ({required this.context});

  @override
  List<Object?> get props => [context];
}

class DarkModeEvent extends ProfileEvent {
  final bool darkMode;

  DarkModeEvent({required this.darkMode});

  @override
  List<Object?> get props => [darkMode];
}

class SignOutEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class ConfirmEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

