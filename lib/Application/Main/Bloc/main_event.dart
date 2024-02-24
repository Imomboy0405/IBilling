part of 'main_bloc.dart';

@immutable
abstract class MainEvent extends Equatable {}

class MainScrollMenuEvent extends MainEvent {
  final int index;

  MainScrollMenuEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class MainMenuButtonEvent extends MainEvent {
  final int index;

  MainMenuButtonEvent({required this.index});

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
