class AuthService {
  static String? _registeredEmail;
  static String? _registeredPassword;

  static void register(String email, String password) {
    _registeredEmail = email;
    _registeredPassword = password;
  }

  static bool login(String email, String password) {
    return email == _registeredEmail && password == _registeredPassword;
  }

  static bool isRegistered() {
    return _registeredEmail != null && _registeredPassword != null;
  }
}
