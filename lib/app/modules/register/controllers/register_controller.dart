import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart'; // Pastikan path sesuai

class RegisterController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() async {
  final username = usernameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text;
  final confirm = confirmPasswordController.text;

  if (username.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
    Get.snackbar('Pendaftaran Gagal', 'Semua field wajib diisi');
    return;
  }

  if (password != confirm) {
    Get.snackbar('Pendaftaran Gagal', 'Password tidak sama');
    return;
  }

  final response = await AuthService.register(username, email, password);
  if (response.containsKey('message')) {
    Get.snackbar('Sukses', response['message']);
    Get.offNamed('/login');
  } else if (response.containsKey('error')) {
    Get.snackbar('Gagal', response['error']);
  } else {
    Get.snackbar('Gagal', 'Terjadi kesalahan tidak diketahui');
  }
}

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}