import 'package:flutter/material.dart';
import 'package:finance_app/screens/auth/register_screen.dart';
import 'package:finance_app/screens/auth/login_screen.dart';
class ProfileScreen extends StatelessWidget {
  // Добавляем параметр key в конструктор
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль пользователя'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Имя: Иван Иванов',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Возраст: 30',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Пол: Мужской',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Цель тренировок: Набор массы',
              style: TextStyle(fontSize: 20),
            ),
            // Add other profile information here
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement profile editing logic
              },
              child: Text('Редактировать профиль'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Вход'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Регистрация'),
            ),


          ],
        ),
      ),
    );
  }
}
