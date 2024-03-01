part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {}

class ProfileInitialState extends ProfileState {
  final bool darkMode;
  final String? phone;
  final String? email;
  ProfileInitialState({required this.darkMode, required this.email, required this.phone});

  @override
  List<Object?> get props => [darkMode, email, phone];
}

class ProfileLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLangState extends ProfileState {
  final Language lang;

  ProfileLangState({required this.lang});

  @override
  List<Object?> get props => [lang];
}

class ProfileSignOutState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileInfoState extends ProfileState {
  @override
  List<Object?> get props => [];
}

