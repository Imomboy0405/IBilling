import 'dart:ui';

import 'package:i_billing/Data/Service/theme_service.dart';

abstract class AppColors {

  static Color get white => ThemeService.getTheme == ThemeMode.dark ? _white : _black;

  static Color get black => ThemeService.getTheme == ThemeMode.dark ? _black : _white;

  static Color get blackBlue => ThemeService.getTheme == ThemeMode.dark ? _darker : _darkerLight;

  static Color get blue => ThemeService.getTheme == ThemeMode.dark ? _blue : _blueLight;

  static Color get transparentBlue => ThemeService.getTheme == ThemeMode.dark ? _transparentBlue : _transparentBlueLight;

  static Color get darkGrey => ThemeService.getTheme == ThemeMode.dark ? _darkGrey : _transparentBlueLight;

  static Color get lightGrey => ThemeService.getTheme == ThemeMode.dark ? _lightGrey : _darkerLight;

  static Color get orange => ThemeService.getTheme == ThemeMode.dark ? _orange : _white;

  static Color get transparentBlueStatus => ThemeService.getTheme == ThemeMode.dark ? _transparentBlue : _cyan;

  static Color get blueStatus => ThemeService.getTheme == ThemeMode.dark ? _blue : _white;

  static Color get transparentRedStatus => ThemeService.getTheme == ThemeMode.dark ? transparentRed : red;

  static Color get redStatus => ThemeService.getTheme == ThemeMode.dark ? red : _white;

  static Color get transparentOrange => ThemeService.getTheme == ThemeMode.dark ? _transparentOrange : _orange;

  static Color get transparentBlack => ThemeService.getTheme == ThemeMode.dark ? _transparentBlack : _transparentWhite;

  static Color get transparentWhite => ThemeService.getTheme == ThemeMode.dark ? _transparentWhite : _transparentBlack;

  static Color get darker => ThemeService.getTheme == ThemeMode.dark ? _darker : _white;

  static Color get dark => ThemeService.getTheme == ThemeMode.dark ? _dark : _white;

  static Color get gray => ThemeService.getTheme == ThemeMode.dark ? _gray : _transparentBlueLight;

  static Color get transparentGray => ThemeService.getTheme == ThemeMode.dark ? _transparentGray : _transparentBlueLight;

  static const _white = Color(0xffffffff);

  static const _black = Color(0xff000000);

  static const _blue = Color(0xff00A795);

  static const _blueLight = Color(0xff4A21EF);

  static const _cyan = Color(0xff1EBBFF);

  static const _transparentBlue = Color(0x3600A795);

  static const _transparentBlueLight = Color(0x364A21EF);

  static const _transparentBlack = Color(0x86000000);

  static const _transparentWhite = Color(0x86ffffff);

  static const _darkGrey = Color(0xff7C7C7C);

  static const _lightGrey = Color(0xffa6a6a6);

  static const _transparentOrange = Color(0x36FDAB2A);

  static const _orange = Color(0xffFDAB2A);

  static const transparentRed = Color(0x36ff0000);

  static const _transparentGray = Color(0x36a5a5a5);

  static const _darker = Color(0xff141416);

  static const _darkerLight = Color(0xff433073);

  static const _dark = Color(0xff2a2a2d);

  static const _gray = Color(0xff4e4e4e);

  static const transparent = Color(0x00000000);

  static const red = Color(0xffff0000);
}