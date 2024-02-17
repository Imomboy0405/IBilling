part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {}

class SignUpErrorState extends SignUpState {
  final bool obscure;
  final bool rememberMe;

  SignUpErrorState({required this.obscure, required this.rememberMe});

  @override
  List<Object?> get props => [obscure, rememberMe];
}

class SignUpEnterState extends SignUpState {
  final bool simple;
  final bool email;
  final bool password;
  final bool username;
  final bool obscure;
  final bool rememberMe;
  final bool phone;

  SignUpEnterState({required this.simple, required this.phone, required this.email, required this.password, required this.obscure, required this.rememberMe, required this.username});

  @override
  List<Object?> get props => [simple, phone, email, password, obscure, rememberMe, username];
}

class SignUpLoadingState extends SignUpState {
  final bool email;
  final bool password;
  final bool username;
  final bool obscure;
  final bool rememberMe;

  SignUpLoadingState({required this.email, required this.password, required this.obscure, required this.rememberMe, required this.username});

  @override
  List<Object?> get props => [email, password, obscure, rememberMe, username];
}
