part of 'main_bloc.dart';

@immutable
abstract class MainState extends Equatable {}

class MainInitialState extends MainState {
  final int screen;
  final Language lang;

  MainInitialState(this.screen, this.lang);

  @override
  List<Object?> get props => [screen, lang];
}

class MainHideBottomNavigationBarState extends MainState {
  @override
  List<Object?> get props => [];
}