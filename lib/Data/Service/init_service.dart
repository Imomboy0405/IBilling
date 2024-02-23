import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:i_billing/Data/Service/theme_service.dart';

import 'lang_service.dart';
import 'locator_service.dart';

class Init {
  static Future initialize() async {
    await _loading();
  }

  static _loading() async {
    await LangService.currentLanguage();
    await ThemeService.currentTheme();
    await Future.delayed(const Duration(seconds: 1));
  }
}