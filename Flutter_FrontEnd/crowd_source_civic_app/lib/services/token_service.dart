import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'jwt_token';
  static const String _tokenTypeKey = 'token_type';

  // Store JWT token
  static Future<void> saveToken(String token, String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_tokenTypeKey, type);
  }

  // Retrieve JWT token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Retrieve token type
  static Future<String?> getTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenTypeKey);
  }

  // Get full authorization header
  static Future<String?> getAuthHeader() async {
    final token = await getToken();
    final type = await getTokenType();

    if (token != null && type != null) {
      return '$type $token';
    }
    return null;
  }

  // Check if token exists
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear token (logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenTypeKey);
  }
}
