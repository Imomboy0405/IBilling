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
  final bool password;
  final bool fullName;
  final bool rePassword;

  OnSubmittedEvent({this.password = false, this.fullName = false, this.rePassword = false});

  @override
  List<Object?> get props => [password, fullName, rePassword];
}

class SignUpButtonEvent extends SignUpEvent {
  final BuildContext context;

  SignUpButtonEvent({required this.context});

  @override
  List<Object?> get props => [context];
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
  final double width;
  final BuildContext context;

  FaceBookEvent({required this.width, required this.context});

  @override
  List<Object?> get props => [width, context];
}

class GoogleEvent extends SignUpEvent {
  final double width;
  final BuildContext context;

  GoogleEvent({required this.width, required this.context});

  @override
  List<Object?> get props => [width, context];
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

class PasswordEyeEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

class RePasswordEyeEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

class SignUpCountryEvent extends SignUpEvent {
  final PhoneCountryData countryData;

  SignUpCountryEvent({required this.countryData});

  @override
  List<Object?> get props => [countryData];
}

class SignUpOnTapCountryButtonEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

class SignUpConfirmEvent extends SignUpEvent {
  final BuildContext context;

  SignUpConfirmEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class SignUpCancelEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

