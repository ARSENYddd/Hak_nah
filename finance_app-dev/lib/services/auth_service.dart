import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://95.174.93.12:8080/fitness'; // Замените на ваш URL API

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
    final Uri url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Парсим токен из ответа API
        String token = jsonDecode(response.body)['token'];
        // Сохраняем токен в SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
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
}
