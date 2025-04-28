part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const PROFILE = _Paths.PROFILE;
  static const ABOUT = _Paths.ABOUT;
  static const ON_BOARDING = _Paths.ON_BOARDING;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const DASHBOARD = '/dashboard';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const PROFILE = '/profile';
  static const ABOUT = '/about';
  static const ON_BOARDING = '/on-boarding';
}
