import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Уведомления'),
      ),
      body: Center(
        child: Text(
          'Здесь будут уведомления.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
