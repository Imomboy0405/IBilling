part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {}

class ProfileInitialState extends ProfileState {
  final bool darkMode;
  ProfileInitialState({required this.darkMode});

  @override
  List<Object?> get props => [darkMode];
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

