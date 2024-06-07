import 'package:flutter/material.dart';
import 'package:finance_app/screens/home/tasks_screen.dart';
import 'package:finance_app/screens/home/recent_activity_screen.dart';
import 'package:finance_app/screens/home/workouts_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная страница'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Добро пожаловать в Fitness Club!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TasksScreen()),
                );
              },
              child: Text('Задания'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecentActivityScreen()),
                );
              },
              child: Text('Последняя активность'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkoutsScreen()),
                );
              },
              child: Text('Тренировки'),
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
