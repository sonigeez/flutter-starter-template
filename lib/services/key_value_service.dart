import 'package:shared_preferences/shared_preferences.dart';

class KeyValueService {
  static const String _userKey = 'user_token';

  // Setters
  static Future<bool> setUserToken(String user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userKey, user);
  }

  // Getters
  static Future<String> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey) ?? '';
  }

  // Clear all stored data
  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
