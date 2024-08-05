import 'package:shared_preferences/shared_preferences.dart';

class KeyValueService {
  static const String _userKey = 'token';

  // Setters
  static Future<bool> setUserToken(String user) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userKey, user);
  }

  // Getters
  static Future<String> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey) ?? '';
  }

  // Clear all stored data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
