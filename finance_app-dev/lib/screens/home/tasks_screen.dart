import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задания'),
      ),
      body: Center(
        child: Text(
          'Здесь будут отображаться задания.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
