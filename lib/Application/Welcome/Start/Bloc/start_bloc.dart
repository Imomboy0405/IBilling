import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../Data/Service/lang_service.dart';
import '../../SignIn/View/sign_in_page.dart';

part 'start_event.dart';
part 'start_state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  Language selectedLang = LangService.getLanguage;
  List<Language> lang = [
    Language.uz,
    Language.ru,
    Language.en,
  ];

  StartBloc() : super(StartInitialState()) {
    on<FlagEvent>(pressFlagButton);
    on<NextEvent>(pressNextButton);
    on<SelectLanguageEvent>(pressLanguageButton);
  }

  void pressFlagButton(FlagEvent event, Emitter emit) {
    emit(StartFlagState());
  }


  void pressNextButton(NextEvent event, Emitter emit) {
    Navigator.pushReplacementNamed(event.context, SignInPage.id);
  }

  Future<void> pressLanguageButton(SelectLanguageEvent event, Emitter emit) async {
    await LangService.language(event.lang);
    selectedLang = event.lang;
    emit(StartFlagState());
    emit(StartInitialState());
  }
}
