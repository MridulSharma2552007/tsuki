import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceStorageService {
  SharedPreferenceStorageService._();
  static final SharedPreferenceStorageService instance =
      SharedPreferenceStorageService._();
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setString({required String key, required String value}) async {
    await _prefs.setString(key, value);
  }

  Future<void> setBool({required String key, required bool value}) async {
    await _prefs.setBool(key, value);
  }

  Future<void> setInt({required String key, required int value}) async {
    await _prefs.setInt(key, value);
  }

  Future<void> remove({required String key}) async {
    await _prefs.remove(key);
  }
}
