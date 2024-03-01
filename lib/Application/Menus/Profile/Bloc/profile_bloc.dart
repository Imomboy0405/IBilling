import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Application/Welcome/SignIn/View/sign_in_page.dart';
import 'package:i_billing/Data/Model/user_model.dart';
import 'package:i_billing/Data/Service/db_service.dart';
import 'package:i_billing/Data/Service/lang_service.dart';
import 'package:i_billing/Data/Service/theme_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final MainBloc mainBloc;
  bool darkMode = ThemeService.getTheme == ThemeMode.dark;
  String fullName = '';
  String dateSign = '';
  String? phoneNumber;
  String? email;
  Language selectedLang = LangService.getLanguage;
  List<Language> lang = [
    Language.uz,
    Language.ru,
    Language.en,
  ];

  ProfileBloc({required this.mainBloc}) : super(ProfileInitialState(darkMode: false, phone: '', email: '')) {
    on<InitialUserEvent>(initialUser);
    on<LanguageEvent>(pressLanguage);
    on<SelectLanguageEvent>(pressSelectLanguage);
    on<CancelEvent>(pressCancel);
    on<DoneEvent>(pressDone);
    on<DarkModeEvent>(pressDarkMode);
    on<SignOutEvent>(pressSignOut);
    on<ConfirmEvent>(pressConfirm);
    on<InfoEvent>(pressInfo);
  }

  void initialUser(InitialUserEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    print('object');
    darkMode = ThemeService.getTheme == ThemeMode.dark;
    mainBloc.darkMode = darkMode;
    selectedLang = LangService.getLanguage;
    String? user = await DBService.loadData(StorageKey.user);
    UserModel  userModel = userFromJson(user!);

    fullName = userModel.fullName!;
    email = userModel.email != null && userModel.email!.isNotEmpty
        ? userModel.email!
        : null;
    phoneNumber = userModel.phoneNumber != null && userModel.phoneNumber!.isNotEmpty
        ? userModel.phoneNumber!
        : null;
    dateSign = userModel.createdTime!;

    emit(ProfileInitialState(darkMode: darkMode, phone: phoneNumber, email: email));
  }

  void pressLanguage(LanguageEvent event, Emitter<ProfileState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    emit(ProfileLangState(lang: selectedLang));
  }

  void pressSelectLanguage(SelectLanguageEvent event, Emitter<ProfileState> emit) {
    selectedLang = event.lang;
    emit(ProfileLangState(lang: selectedLang));
  }

  void pressCancel(CancelEvent event, Emitter<ProfileState> emit) {
    selectedLang = LangService.getLanguage;
    mainBloc.add(MainLanguageEvent());
    emit(ProfileInitialState(darkMode: darkMode, phone: phoneNumber, email: email));
  }

  Future<void> pressDone(DoneEvent event, Emitter<ProfileState> emit) async {
    await LangService.language(selectedLang);
    mainBloc.add(MainLanguageEvent());
    emit(ProfileInitialState(darkMode: darkMode, phone: phoneNumber, email: email));
  }

  Future<void> pressDarkMode(DarkModeEvent event, Emitter<ProfileState> emit) async {
    darkMode = event.darkMode;
    mainBloc.darkMode = darkMode;
    await ThemeService.theme(darkMode ? ThemeMode.dark : ThemeMode.light);
    emit(ProfileInitialState(darkMode: darkMode, phone: phoneNumber, email: email));
  }

  void pressSignOut(SignOutEvent event, Emitter<ProfileState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    emit(ProfileSignOutState());
  }

  void pressConfirm(ConfirmEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    await DBService.deleteData(StorageKey.user);
    if (event.context.mounted) {
      Navigator.pushNamedAndRemoveUntil(event.context, SignInPage.id, (route) => false);
    }
  }

  void pressInfo(InfoEvent event, Emitter<ProfileState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    emit(ProfileInfoState());
  }
}
