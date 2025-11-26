import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AsyncPreferences {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  Future<void> setStringValue(String key, String value) async {
    await asyncPrefs.remove(key);
    await asyncPrefs.setString(key, value);
  }

  Future<String?> getStringValue(String key) async {
    final String? value = await asyncPrefs.getString(key);
    return value;
  }

  Future<void> setIntValue(String key, int value) async {
    await asyncPrefs.remove(key);
    await asyncPrefs.setInt(key, value);
  }

  Future<void> removeIntValue(String key) async {
    await asyncPrefs.remove(key);
  }

  Future<int?> getIntValue(String key) async {
    final int? value = await asyncPrefs.getInt(key);
    return value;
  }

  Future<void> setBoolValue(String key, bool value) async {
    await asyncPrefs.remove(key);
    await asyncPrefs.setBool(key, value);
  }

  Future<double?> getDoubleValue(String key) async {
    final double? value = await asyncPrefs.getDouble(key);
    return value;
  }

  Future<void> setDoubleValue(String key, double value) async {
    await asyncPrefs.remove(key);
    await asyncPrefs.setDouble(key, value);
  }

  Future<bool?> getBoolValue(String key) async {
    final bool? value = await asyncPrefs.getBool(key);
    return value;
  }

  Future<void> clearPreferences() async {
    await asyncPrefs.clear();
  }
}

final sharedPrefsProvider = Provider<SharedPreferencesWithCache>((ref) {
  throw UnimplementedError(); 
});