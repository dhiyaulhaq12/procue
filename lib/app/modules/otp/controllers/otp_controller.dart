import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class OtpController extends GetxController {
  final otpController = TextEditingController();
  final email = ''.obs; // Akan diisi dari register

  void verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar('Gagal', 'OTP wajib diisi');
      return;
    }

    final response = await AuthService.verifyOtp(email.value, otp);

    if (response['message'] == 'OTP valid') {
      Get.snackbar('Berhasil', 'OTP valid, lanjut isi password');
      Get.toNamed('/register-complete', arguments: {'email': email.value});
    } else {
      Get.snackbar('Gagal', response['error'] ?? 'OTP salah atau sudah kedaluwarsa');
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
