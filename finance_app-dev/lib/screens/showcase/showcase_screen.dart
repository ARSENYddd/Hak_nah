// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({Key? key}) : super(key: key);

  // TODO: Сделать ссылки на новые окна

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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => TasksScreen()),
                // );
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
                width: 150, // Ширина кнопки
                alignment: Alignment.center, // Выравнивание текста по центру
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => TasksScreen()),
                // );
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
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Витрина'),
  //     ),
  //     body: Center(
  //       child: Text(
  //         'Здесь будет витрина.',
  //         style: TextStyle(fontSize: 24),
  //       ),
  //     ),
  //   );
  // }
}
