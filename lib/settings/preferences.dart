import 'package:shared_preferences/shared_preferences.dart';

class AsyncPreferences {
  static final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();

  static Future<void> setStringValue(String key, String value) async {
    await _asyncPrefs.remove(key);
    await _asyncPrefs.setString(key, value);
  }

  static Future<String?> getStringValue(String key) async {
    final String? value = await _asyncPrefs.getString(key);
    return value;
  }

  static Future<void> setIntValue(String key, int value) async {
    await _asyncPrefs.remove(key);
    await _asyncPrefs.setInt(key, value);
  }

  static Future<void> removeIntValue(String key) async {
    await _asyncPrefs.remove(key);
  }

  static Future<int?> getIntValue(String key) async {
    final int? value = await _asyncPrefs.getInt(key);
    return value;
  }

  static Future<void> setBoolValue(String key, bool value) async {
    await _asyncPrefs.remove(key);
    await _asyncPrefs.setBool(key, value);
  }

  static Future<double?> getDoubleValue(String key) async {
    final double? value = await _asyncPrefs.getDouble(key);
    return value;
  }

  static Future<void> setDoubleValue(String key, double value) async {
    await _asyncPrefs.remove(key);
    await _asyncPrefs.setDouble(key, value);
  }

  static Future<bool?> getBoolValue(String key) async {
    final bool? value = await _asyncPrefs.getBool(key);
    return value;
  }

  static Future<void> clearPreferences() async {
    await _asyncPrefs.clear();
  }
}