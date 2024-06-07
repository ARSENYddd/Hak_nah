import 'package:flutter/material.dart';

class RecentActivityScreen extends StatelessWidget {
  const RecentActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Последняя активность'),
      ),
      body: Center(
        child: Text(
          'Здесь будет отображаться последняя активность.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
