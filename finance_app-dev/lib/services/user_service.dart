// lib/services/user_service.dart
import 'auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  final AuthService _authService;

  UserService(this._authService);

  Future<bool> registerUser(String email, String password, String firstName) async {
    // Регистрируем нового пользователя
    return _authService.register(email, password, firstName);
  }

  Future<bool> authenticateUser(String email, String password) {
    // Аутентификация пользователя
    return _authService.login(email, password);
  }

  Future<String?> getToken() {
    // Получаем токен из AuthService
    return _authService.getToken();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    String? accessToken = await _authService.getToken();

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final Uri url = Uri.parse('http://95.174.93.12:8080/fitness/user');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // Access token is expired or invalid, refresh it
        bool refreshed = await _authService.refreshTokens();
        if (refreshed) {
          return fetchUserData(); // Retry fetching user data
        } else {
          // Handle the error appropriately
          throw Exception('Failed to refresh token');
        }
      } else {
        // Handle other status codes appropriately
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Failed to load user data');
    }
  }
}
