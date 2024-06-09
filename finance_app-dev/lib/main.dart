import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_app/screens/auth/login_screen.dart';
import 'package:finance_app/screens/auth/register_screen.dart';
import 'package:finance_app/screens/main_screen.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:finance_app/services/user_service.dart';
import 'package:finance_app/screens/profile/profile_screen.dart';

class AppMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        switch (result) {
          case 'login':
            Navigator.pushNamed(context, '/login');
            break;
          case 'register':
            Navigator.pushNamed(context, '/register');
            break;
          case 'profile':
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'login',
          child: Text('Вход'),
        ),
        const PopupMenuItem<String>(
          value: 'register',
          child: Text('Регистрация'),
        ),
        const PopupMenuItem<String>(
          value: 'profile',
          child: Text('Профиль пользователя'),
        ),
      ],
    );
  }
}

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
          update: (context, authService, _) => UserService(authService),
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
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/profile' : (context) => ProfileScreen()
          // Add other routes here if needed
        },
      ),
    );
  }
}
