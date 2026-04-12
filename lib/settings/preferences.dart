import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

abstract class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> _setValue({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
    return;
  }

  Future<String?> _readValue({required String key}) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteData() async {
    await _storage.deleteAll();
  }
}

class SpotifySecureStorage extends SecureStorage {
  Future<String?> getCodeVerifier() async {
    final String? codeVerifier = await _readValue(key: 'spotify-code_verifier');
    return codeVerifier;
  }

  Future<String?> getStateCode() async {
    final String? stateCode = await _readValue(key: 'spotify-state_code');
    return stateCode;
  }

  Future<String?> getAuthToken() async {
    final String? authToken = await _readValue(key: 'spotify-auth_token');
    return authToken;
  }

  Future<String?> getRefreshToken() async {
    final String? refreshToken = await _readValue(key: 'spotify-refresh_token');
    return refreshToken;
  }

  Future<void> setCodeVerifier(String codeVerifier) async {
    await _setValue(key: 'spotify-code_verifier', value: codeVerifier);
    return;
  }

  Future<void> setStateCode(String stateCode) async {
    await _setValue(key: 'spotify-state_code', value: stateCode);
    return;
  }
  
  Future<void> setAuthToken(String authToken) async {
    await _setValue(key: 'spotify-auth_token', value: authToken);
    return;
  }

  Future<void> setRefreshToken(String refrehToken) async {
    await _setValue(key: 'spotify-refresh_token', value: refrehToken);
    return;
  }
}