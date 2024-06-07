import 'package:flutter/material.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тренировки'),
      ),
      body: Center(
        child: Text(
          'Здесь будут отображаться тренировки.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
