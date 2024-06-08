import 'auth_service.dart';

class UserService {
  final AuthService _authService;

  UserService(this._authService);

  Future<bool> registerUser(String email, String password, String firstName) async {
    // Регистрируем нового пользователя
    return _authService.register(email, password, firstName);
  }

  Future<bool> authenticateUser(String email, String password) {
    // Аутентификация пользователя
    return _authService.login(email, password);
  }

  Future<String?> getToken() {
    // Получаем токен из AuthService
    return _authService.getToken();
  }
}
