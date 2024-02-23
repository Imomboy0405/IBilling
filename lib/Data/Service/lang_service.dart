import 'db_service.dart';
import 'locals/en_us.dart';
import 'locals/ru_ru.dart';
import 'locals/uz_uz.dart';

enum Language { en, ru, uz }

abstract class LangService {
  static Language _language = Language.uz;

  static Future<Language> currentLanguage() async {
    String? lang = await DBService.loadData(StorageKey.lang);
    _language = _stringToLanguage(lang);
    return _language;
  }

  // setter
  static Future<void> language(Language language) async {
    _language = language;
    await DBService.saveLang(language.name);
  }

  // getter
  static Language get getLanguage => _language;

  static Language _stringToLanguage(String? lang) {
    switch (lang) {
      case "en":
        return Language.en;
      case "ru":
        return Language.ru;
      default:
        return Language.uz;
    }
  }
}

extension Translation on String {
  String tr({Language? language}) {
    switch (language ?? LangService.getLanguage) {
      case Language.en:
        return enUS[this] ?? 'EN_NULL';
      case Language.ru:
        return ruRU[this] ?? 'RU_NULL';
      case Language.uz:
        return uzUZ[this] ?? 'UZ_NULL';
    }
  }
}
