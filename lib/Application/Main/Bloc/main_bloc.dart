import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:i_billing/Data/Model/contract_model.dart';
import 'package:i_billing/Data/Model/history_model.dart';
import 'package:i_billing/Data/Model/invoice_model.dart';
import 'package:i_billing/Data/Model/saved_model.dart';
import 'package:i_billing/Data/Model/user_model.dart';
import 'package:i_billing/Data/Service/lang_service.dart';
import 'package:i_billing/Data/Service/theme_service.dart' as theme;

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  bool darkMode = theme.ThemeService.getTheme == theme.ThemeMode.dark;
  Language language = LangService.getLanguage;

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

  late UserModel userModel;
  int selectedDay = DateTime.now().day;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  double dayControllerPixels = 0;
  List<InvoiceModel> invoices = [];
  List<ContractModel> contracts = [];
  List<ContractModel> filterContracts = [];
  List<InvoiceModel> filterInvoices = [];
  Iterable<ContractModel> suggestions = [];
  List<ContractModel> historyListContracts = [];
  List<ContractModel> historyListSavedContracts = [];
  List<ContractModel> historyListHistoryContracts = [];
  List<ContractModel> savedContracts = [];
  List<InvoiceModel> savedInvoices = [];
  HistoryModel historyModel = HistoryModel(history: [], savedHistory: [], historyHistory: []);
  SavedModel savedModel = SavedModel();
  List<ContractModel> historyContracts = [];
  List<InvoiceModel> historyInvoices = [];

  MainBloc() : super(MainInitialState(
    screen: 1,
    lang: LangService.getLanguage,
    darkMode: theme.ThemeService.getTheme == theme.ThemeMode.dark,
    selectedDay: DateTime.now().day,
    selectedMonth: DateTime.now().month,
    selectedYear: DateTime.now().year,
    dayControllerPixels: 0,
  )) {
    on<MainScrollMenuEvent>(scrollMenu);
    on<MainMenuButtonEvent>(pressMenuButton);
    on<MainHideBottomNavigationBarEvent>(hideBottomNavigationBar);
    on<MainLanguageEvent>(languageUpdate);
    on<MainThemeEvent>(themeUpdate);
  }

  void emitComfort(Emitter<MainState> emit) {
    emit(MainInitialState(
      screen: currentScreen,
      lang: language,
      darkMode: darkMode,
      selectedDay: selectedDay,
      selectedMonth: selectedMonth,
      selectedYear: selectedYear,
      dayControllerPixels: dayControllerPixels,
    ));
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
          duration: Duration(milliseconds: (currentScreen - oldScreen)  * 50 + 150),
          curve: Curves.linear);
      emitComfort(emit);
    }
    else if(event.index + 1 < oldScreen) {
      currentScreen = event.index + 1;
      await controller.animateToPage(
          currentScreen,
          duration: Duration(milliseconds: (oldScreen - currentScreen)  * 50 + 150),
          curve: Curves.linear);
      currentScreen--;
      emitComfort(emit);
    }
    oldScreen = currentScreen;
    menuButtonPressed = false;
  }

  Future<void> scrollMenu(MainScrollMenuEvent event, Emitter<MainState> emit) async {
    await controller.animateToPage(currentScreen, duration: const Duration(milliseconds: 150), curve: Curves.easeOut);
    emitComfort(emit);
  }

  void hideBottomNavigationBar(MainHideBottomNavigationBarEvent event, Emitter<MainState> emit) {
    emit(MainHideBottomNavigationBarState());
  }

  void languageUpdate(MainLanguageEvent event, Emitter<MainState> emit) {
    language = LangService.getLanguage;
    emitComfort(emit);
  }

  void themeUpdate(MainThemeEvent event, Emitter<MainState> emit) {
    darkMode = theme.ThemeService.getTheme == theme.ThemeMode.dark;
    emitComfort(emit);
  }
}
