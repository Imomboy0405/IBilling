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

  OnSubmittedEvent({this.password = false, this.fullName = false});

  @override
  List<Object?> get props => [password];
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
  final double width;

  FaceBookEvent({required this.width});

  @override
  List<Object?> get props => [width];
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

