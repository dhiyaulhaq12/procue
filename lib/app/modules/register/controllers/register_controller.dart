import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart'; // Pastikan path sesuai

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      Get.snackbar('Pendaftaran Gagal', 'Semua field wajib diisi');
      return;
    }

    if (password != confirm) {
      Get.snackbar('Pendaftaran Gagal', 'Password tidak sama');
      return;
    }

    // Simpan ke AuthService
    AuthService.register(email, password);

    Get.snackbar('Berhasil', 'Pendaftaran berhasil');
    Get.offNamed('/login');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
