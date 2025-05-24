import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class RegisterController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<Map<String, dynamic>> register() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    // Validasi semua field
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      return {
        'success': false,
        'message': 'Semua field wajib diisi',
      };
    }

    // Validasi email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return {
        'success': false,
        'message': 'Format email tidak valid',
      };
    }

    // Validasi konfirmasi password
    if (password != confirm) {
      return {
        'success': false,
        'message': 'Password dan konfirmasi tidak sama',
      };
    }

    // Kirim data ke AuthService
    final response = await AuthService.register(username, email, password);

    if (response['success'] == true) {
      return {
        'success': true,
        'message': response['message'] ?? 'Registrasi berhasil',
      };
    } else {
      return {
        'success': false,
        'message': response['message'] ?? 'Terjadi kesalahan saat registrasi',
      };
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
