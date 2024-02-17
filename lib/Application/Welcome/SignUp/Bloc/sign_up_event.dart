part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {}

class SelectLanguageEvent extends SignUpEvent {
  final Language lang;

  SelectLanguageEvent({required this.lang});

  @override
  List<Object?> get props => [lang];
}

class SignUpChangeEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

class OnSubmittedEvent extends SignUpEvent {
  final bool username;

  OnSubmittedEvent({this.username = false});

  @override
  List<Object?> get props => [username];
}

class SignUpButtonEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

class PhoneButtonEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

class EmailButtonEvent extends SignUpEvent {
  final double width;

  EmailButtonEvent({required this.width});

  @override
  List<Object?> get props => [width];
}

class FaceBookEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

class GoogleEvent extends SignUpEvent {
  final double width;

  GoogleEvent({required this.width});

  @override
  List<Object?> get props => [width];
}

class SignInEvent extends SignUpEvent {
  final BuildContext context;

  SignInEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class RememberMeEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

class EyeEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}