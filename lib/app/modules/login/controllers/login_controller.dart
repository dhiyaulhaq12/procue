import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Login Gagal', 'Email dan password wajib diisi');
      return;
    }

    if (AuthService.login(email, password)) {
      Get.offAllNamed('/dashboard');
    } else {
      Get.snackbar('Login Gagal', 'Email atau password salah');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
