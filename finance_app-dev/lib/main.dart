import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_app/screens/auth/login_screen.dart';
import 'package:finance_app/screens/auth/register_screen.dart';
import 'package:finance_app/screens/main_screen.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:finance_app/services/user_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ProxyProvider<AuthService, UserService>(
          update: (_, authService, __) => UserService(authService),
        ),
      ],
      child: MaterialApp(
        title: 'Fitness Club App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MainScreen(),

          // Add other routes here if needed
        },
      ),
    );
  }
}
