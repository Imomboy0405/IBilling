part of 'main_bloc.dart';

@immutable
abstract class MainEvent extends Equatable {}

class MainMenuEvent extends MainEvent {
  final int index;

  MainMenuEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class MainChangeEvent extends MainEvent {
  final int index;

  MainChangeEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class MainHideBottomNavigationBarEvent extends MainEvent {

  @override
  List<Object?> get props => [];
}

class MainLanguageEvent extends MainEvent {

  @override
  List<Object?> get props => [];
}
