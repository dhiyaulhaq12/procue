import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    if (response['success'] == true && response.containsKey('access_token')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response['access_token']);  // Simpan token

      // Cek dan print token yang sudah disimpan
      print('Token after login saved: ${prefs.getString('access_token')}');

      Get.snackbar('Sukses', response['message']);
      Get.offNamed('/dashboard');
    } else {
      Get.snackbar('Login Gagal', response['message'] ?? 'Terjadi kesalahan');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
