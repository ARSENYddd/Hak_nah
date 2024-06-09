import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://kualsoft.ru/fitness/'; // Замените на ваш URL API

  Future<bool> register(String login, String password, String firstName) async {
    final String url = '$baseUrl/user/create';

    Map<String, dynamic> requestBody = {
      'login': login,
      'password': password,
      'firstName': firstName,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        // Если сервер вернул ошибку, возвращаем false и передаем сообщение об ошибке
        return false;
      }
    } catch (e) {
      // В случае возникновения исключения также возвращаем false и сообщаем об ошибке
      print('Error registering user: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    final Uri url = Uri.parse('$baseUrl/token');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'login': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Парсим токены из ответа API
        final responseBody = jsonDecode(response.body);
        String accessToken = responseBody['accessToken'];
        String refreshToken = responseBody['refreshToken'];

        // Сохраняем токены в SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);

        print('Access Token: $accessToken');
        print('Refresh Token: $refreshToken');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error logging in: $e');
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future<bool> refreshTokens() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) {
      return false;
    }

    final Uri refreshUrl = Uri.parse('https://kualsoft.ru/fitness/refresh');

    try {
      final response = await http.post(
        refreshUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        String newAccessToken = responseBody['accessToken'];
        String newRefreshToken = responseBody['refreshToken'];

        await prefs.setString('accessToken', newAccessToken);
        await prefs.setString('refreshToken', newRefreshToken);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error refreshing tokens: $e');
      return false;
    }
  }
}
