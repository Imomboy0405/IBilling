import 'db_service.dart';

enum ThemeMode { dark, light }

abstract class ThemeService {
  static ThemeMode _themeMode = ThemeMode.dark;

  static Future<ThemeMode> currentTheme() async {
    String? theme = await DBService.loadData(StorageKey.theme);
    _themeMode = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    return _themeMode;
  }

  // setter
  static Future<void> theme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await DBService.saveTheme(themeMode.name);
  }

  // getter
  static ThemeMode get getTheme => _themeMode;
}
