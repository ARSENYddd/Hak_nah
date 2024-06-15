// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'coaches_screen.dart';
import 'exercises_screen.dart';// Добавьте импорт для экрана тренеров

class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Витрина'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Выберите нужный раздел:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoachesScreen()),
                );
              },
              child: Container(
                height: 50,
                width: 150, // Ширина кнопки
                alignment: Alignment.center, // Выравнивание текста по центру
                child: Text('Тренера', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => TasksScreen()),
                // );
              },
              child: Container(
                height: 50,
                width: 150,
                alignment: Alignment.center,
                child: Text('Тренировки', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => TasksScreen()),
                // );
              },
              child: Container(
                height: 50,
                width: 150, // Ширина кнопки
                alignment: Alignment.center, // Выравнивание текста по центру
                child: Text('Рецепты', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExercisesListPage()),
                );
              },
              child: Container(
                height: 50,
                width: 150, // Ширина кнопки
                alignment: Alignment.center, // Выравнивание текста по центру
                child: Text('Упражнения', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
