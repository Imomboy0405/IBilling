part of 'main_bloc.dart';

@immutable
abstract class MainState extends Equatable {}

class MainInitialState extends MainState {
  final int screen;
  final Language lang;
  final bool darkMode;
  final int selectedDay;
  final int selectedMonth;
  final int selectedYear;
  final double dayControllerPixels;

  MainInitialState({
    required this.screen,
    required this.lang,
    required this.darkMode,
    required this.selectedDay,
    required this.selectedMonth,
    required this.selectedYear,
    required this.dayControllerPixels,
  });

  @override
  List<Object?> get props => [screen, lang, darkMode, selectedDay, selectedMonth, selectedYear, dayControllerPixels];
}

class MainHideBottomNavigationBarState extends MainState {
  @override
  List<Object?> get props => [];
}
