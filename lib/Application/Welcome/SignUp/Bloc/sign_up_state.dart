part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {}

class SignUpErrorState extends SignUpState {
  final bool obscure;

  SignUpErrorState({required this.obscure});

  @override
  List<Object?> get props => [obscure];
}

class SignUpEnterState extends SignUpState {
  final bool simple;
  final bool email;
  final bool password;
  final bool fullName;
  final bool obscure;
  final bool phone;

  SignUpEnterState(
      {required this.simple,
      required this.phone,
      required this.email,
      required this.password,
      required this.obscure,
      required this.fullName});

  @override
  List<Object?> get props =>
      [simple, phone, email, password, obscure, fullName];
}

class SignUpLoadingState extends SignUpState {
  final bool email;
  final bool password;
  final bool fullName;
  final bool obscure;

  SignUpLoadingState(
      {required this.email,
      required this.password,
      required this.obscure,
      required this.fullName});

  @override
  List<Object?> get props => [email, password, obscure, fullName];
}

class SignUpFlagState extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpVerifyPhoneState extends SignUpState {
  @override
  List<Object?> get props => [];
}

