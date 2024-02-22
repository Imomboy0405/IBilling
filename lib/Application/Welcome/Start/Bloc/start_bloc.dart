import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';

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
    on<TermsEvent>(pressTermsButton);
    on<SelectLanguageEvent>(pressLanguageButton);
  }

  void pressFlagButton(FlagEvent event, Emitter emit) {
    emit(StartFlagState());
  }

  void pressNextButton(NextEvent event, Emitter emit) {
    Navigator.pushReplacementNamed(event.context, SignInPage.id);
  }

  Future<void> pressTermsButton(TermsEvent event, Emitter emit) async {
    if (event.policy) {
      await launchUrl(
          Uri(path: 'www.termsfeed.com/live/cfc44701-8782-4bc1-86c6-95a33a2c361c',
              scheme: 'https'), mode: LaunchMode.inAppWebView);
    } else {
      await launchUrl(
          Uri(path: 'www.privacypolicies.com/live/ab899bd1-c90f-439a-a149-b849ada1e61d',
              scheme: 'https', ), mode: LaunchMode.inAppWebView);
    }
  }

  Future<void> pressLanguageButton(SelectLanguageEvent event, Emitter emit) async {
    await LangService.language(event.lang);
    selectedLang = event.lang;
    emit(StartFlagState());
    emit(StartInitialState());
  }
}
