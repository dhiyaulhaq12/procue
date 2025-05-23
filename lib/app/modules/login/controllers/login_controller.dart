import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Gagal', 'Email dan password wajib diisi');
      return;
    }

    final response = await AuthService.login(email, password);
    if (response.containsKey('access_token')) {
      // Simpan token ke SharedPreferences kalau mau
      Get.snackbar('Sukses', 'Login berhasil');
      Get.offNamed('/dashboard');
    } else {
      Get.snackbar('Login Gagal', response['error'] ?? 'Terjadi kesalahan');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
