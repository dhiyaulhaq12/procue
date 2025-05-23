import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

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

    // Validasi field tidak boleh kosong
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      Get.snackbar('Pendaftaran Gagal', 'Semua field wajib diisi');
      return;
    }

    // Validasi format email yang benar
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      Get.snackbar('Pendaftaran Gagal', 'Email tidak valid');
      return;
    }

    // Validasi password sama
    if (password != confirm) {
      Get.snackbar('Pendaftaran Gagal', 'Password tidak sama');
      return;
    }

    // Kirim ke backend
    final response = await AuthService.register(username, email, password);

    if (response.containsKey('message') && response['message'] == 'User registered successfully') {
      Get.snackbar('Sukses', response['message']);
      Get.offNamed('/login');
    } else {
      // Tangani semua kemungkinan pesan error
      final errorMsg = response['message'] ?? response['error'] ?? 'Terjadi kesalahan tidak diketahui';
      Get.snackbar('Gagal', errorMsg);
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
