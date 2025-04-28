import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  void resetPassword() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Gagal', 'Email wajib diisi');
      return;
    }

    // Simulasi pengiriman email
    Get.snackbar('Berhasil', 'Link reset password telah dikirim ke $email');
    Get.back(); // Kembali ke login page
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
