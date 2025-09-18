import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _kAccess = 'auth_token';
  static const _kRefresh = 'refresh_token';

  // ---- Save from login response ----
  static Future<void> saveFromResponse(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    final access = data['access_token'] as String?;
    final refresh = data['refresh_token'] as String?;

    if (access != null) {
      await prefs.setString(_kAccess, access);
    }
    if (refresh != null) {
      await prefs.setString(_kRefresh, refresh);
    }
  }

  // ---- tokens ----
  static Future<void> saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccess, access);
    await prefs.setString(_kRefresh, refresh);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAccess);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRefresh);
  }

  static Future<Map<String, String>?> getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final access = prefs.getString(_kAccess);
    final refresh = prefs.getString(_kRefresh);
    if (access == null || refresh == null) return null;
    return {'access': access, 'refresh': refresh};
  }

  static Future<void> updateAccessToken(String newAccess) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccess, newAccess);
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAccess);
    await prefs.remove(_kRefresh);
  }

  // ---- “remember me” credentials (email+password) ----
  static Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setBool('remember_me', true);
  }

  static Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('remember_me') ?? false)) return null;
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('remember_me');
  }
}
