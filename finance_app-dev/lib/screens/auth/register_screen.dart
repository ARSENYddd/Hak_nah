import 'package:flutter/material.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _loginController,
              decoration: InputDecoration(labelText: 'Логин'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Имя'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String login = _loginController.text;
                String password = _passwordController.text;
                String firstName = _firstNameController.text;

                // Регистрируем пользователя
                bool success = await Provider.of<AuthService>(context, listen: false)
                    .register(login, password, firstName);

                // Если регистрация успешна, переходим на экран входа
                if (success) {
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  // Если регистрация не удалась, показываем сообщение об ошибке
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка регистрации. Попробуйте еще раз.')),
                  );
                }
              },
              child: Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
