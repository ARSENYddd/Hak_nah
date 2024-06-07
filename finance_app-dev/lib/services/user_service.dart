import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class UserService {
  final String baseUrl = 'https://yourapi.com/api';  // Замените на ваш URL API
  final AuthService authService;

  UserService(this.authService);

  Future<Map<String, dynamic>?> getUserProfile() async {
    final token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

// Добавьте другие методы для работы с пользователем, если необходимо
}
