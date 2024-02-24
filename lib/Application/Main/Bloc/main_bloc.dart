import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:i_billing/Data/Service/lang_service.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  int currentScreen = 1;
  int oldScreen = 1;
  bool menuButtonPressed = false;
  final List<AssetImage> listOfMenuIcons = [
    const AssetImage('assets/icons/ic_menu_contract_outlined.png'),
    const AssetImage('assets/icons/ic_menu_history_outlined.png'),
    const AssetImage('assets/icons/ic_menu_new_outlined.png'),
    const AssetImage('assets/icons/ic_menu_saved_outlined.png'),
    const AssetImage('assets/icons/ic_menu_profile_outlined.png'),
    const AssetImage('assets/icons/ic_menu_contract.png'),
    const AssetImage('assets/icons/ic_menu_history.png'),
    const AssetImage('assets/icons/ic_menu_new.png'),
    const AssetImage('assets/icons/ic_menu_saved.png'),
    const AssetImage('assets/icons/ic_menu_profile.png'),
  ];

  final List<String> listOfMenuTexts = [
    'contracts',
    'history',
    'new',
    'saved',
    'profile',
  ];
  PageController controller = PageController(keepPage: true, initialPage: 1);

  MainBloc() : super(MainInitialState(1, LangService.getLanguage)) {
    on<MainScrollMenuEvent>(scrollMenu);
    on<MainMenuButtonEvent>(pressMenuButton);
    on<MainHideBottomNavigationBarEvent>(hideBottomNavigationBar);
    on<MainLanguageEvent>(languageUpdate);
  }

  void listen() {
    if (controller.page! <= 0.001) {
      controller.jumpToPage(5);
    } else if (controller.page! >= 5.999) {
      controller.jumpToPage(1);
    }

    if ((!menuButtonPressed) &&
        controller.page! - controller.page!.truncate() < 0.2
        || controller.page! - controller.page!.truncate() > 0.8){
      currentScreen = controller.page!.round();
    }

    if (currentScreen != oldScreen && !menuButtonPressed) {
      oldScreen = currentScreen;
      add(MainScrollMenuEvent(index: currentScreen));
    }
  }

  Future<void> pressMenuButton(MainMenuButtonEvent event, Emitter<MainState> emit) async {
    menuButtonPressed = true;
    if(oldScreen < event.index + 1) {
      currentScreen = event.index + 1;
      await controller.animateToPage(
          currentScreen,
          duration: Duration(milliseconds: (currentScreen - oldScreen)  * 50 + 200),
          curve: Curves.linear);
      emit(MainInitialState(currentScreen, LangService.getLanguage));
    }
    else if(event.index + 1 < oldScreen) {
      currentScreen = event.index + 1;
      await controller.animateToPage(
          currentScreen,
          duration: Duration(milliseconds: (oldScreen - currentScreen)  * 50 + 150),
          curve: Curves.linear);
      emit(MainInitialState(--currentScreen, LangService.getLanguage));
    }
    oldScreen = currentScreen;
    menuButtonPressed = false;
  }

  Future<void> scrollMenu(MainScrollMenuEvent event, Emitter<MainState> emit) async {
    await controller.animateToPage(currentScreen, duration: const Duration(milliseconds: 150), curve: Curves.easeOut);
    emit(MainInitialState(currentScreen, LangService.getLanguage));
  }

  void hideBottomNavigationBar(MainHideBottomNavigationBarEvent event, Emitter<MainState> emit) {
    emit(MainHideBottomNavigationBarState());
  }

  void languageUpdate(MainLanguageEvent event, Emitter<MainState> emit) {
    emit(MainInitialState(currentScreen, LangService.getLanguage));
  }
}
