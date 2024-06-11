import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_app/widgets/drop_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, dynamic>> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? '';

    final Uri url = Uri.parse('https://kualsoft.ru/fitness/user');

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
        bool refreshed = await refreshTokens();
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

  Future<bool> refreshTokens() async {
    final prefs = await SharedPreferences.getInstance();
    String refreshToken = prefs.getString('refreshToken') ?? '';

    final Uri refreshUrl =
        Uri.parse('http://95.174.93.12:8080/fitness/refresh');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          AppMenu(), // Добавление AppMenu в AppBar
        ],
        title: Text('Профиль пользователя'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки данных'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Имя: ${userData['firstName']} ${userData['lastName']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Дата рождения: ${userData['birthDate']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Пол: ${userData['genderId']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Рост: ${userData['heightCm']} см',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Вес: ${userData['weightKg']} кг',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Implement profile editing logic
                    },
                    child: Text('Редактировать профиль'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('Вход'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text('Регистрация'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Нет данных'));
          }
        },
      ),
    );
  }
}
