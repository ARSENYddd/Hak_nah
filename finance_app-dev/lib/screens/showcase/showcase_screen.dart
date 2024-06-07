import 'package:flutter/material.dart';

class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Витрина'),
      ),
      body: Center(
        child: Text(
          'Здесь будет витрина.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
