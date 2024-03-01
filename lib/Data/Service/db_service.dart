import 'package:i_billing/Data/Model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey { lang, theme, user }

class DBService {
  static Future<bool> saveLang(String lang) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(StorageKey.lang.name, lang);
  }

  static Future<bool> saveTheme(String theme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(StorageKey.theme.name, theme);
  }

  static Future<bool> saveUser(UserModel user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(StorageKey.user.name, userToJson(user));
  }

  static Future<String?> loadData(StorageKey storageKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(storageKey.name);
  }

  static Future<bool> deleteData(StorageKey storageKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.remove(storageKey.name);
  }
}
