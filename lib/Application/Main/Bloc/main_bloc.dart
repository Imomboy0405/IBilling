import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  int currentScreen = 1;
  int oldScreen = 1;
  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.favorite_rounded,
    Icons.person_rounded,
  ];
  PageController controller = PageController(keepPage: true, initialPage: 1);

  MainBloc() : super(MainInitialState(1)) {
    on<MainMenuEvent>(pressMenu);
    on<MainChangeEvent>(change);
  }

  Future<void> change(MainChangeEvent event, Emitter<MainState> emit) async {
    currentScreen = event.index + 1;
    controller.jumpToPage(currentScreen);
    emit(MainInitialState(currentScreen));
  }

  Future<void> pressMenu(MainMenuEvent event, Emitter<MainState> emit) async {
    controller.animateToPage(currentScreen, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    emit(MainInitialState(currentScreen));
  }
}
