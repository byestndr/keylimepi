import 'package:shared_preferences/shared_preferences.dart';

class preferences {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  Future<void> setStringValue(String key, String value) async {
    await prefs.remove(key);
    await prefs.setString(key, value);
  }

  Future<String?> getStringValue(String key) async {
    final String? value = await prefs.getString(key);
    return value;
  }

  Future<void> setIntValue(String key, int value) async{
    await prefs.remove(key);
    await prefs.setInt(key, value);
  }

  Future<void> removeIntValue(String key) async{
    await prefs.remove(key);
  }

  Future<int?> getIntValue(String key) async{
    final int? value = await prefs.getInt(key);
    return value;
  }

  Future<void> setBoolValue(String key, bool value) async {
    await prefs.remove(key);
    await prefs.setBool(key, value);
  }

  Future<bool?> getBoolValue(String key) async{
    final bool? value = await prefs.getBool(key);
    return value;
  }

  Future<void> ClearPreferences() async {
    await prefs.clear();
  }
}