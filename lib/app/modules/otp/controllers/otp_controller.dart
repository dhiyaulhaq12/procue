import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class OtpController extends GetxController {
  final otpController = TextEditingController();
  final email = ''.obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['email'] != null) {
      email.value = args['email'];
    }
  }

  void verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar('Gagal', 'OTP wajib diisi',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final response = await AuthService.verifyOtp(email.value, otp);

      if (response['success'] == true) {
        Get.snackbar(
            'Berhasil', response['message'] ?? 'OTP berhasil diverifikasi',
            backgroundColor: Colors.green, colorText: Colors.white);

        // Ganti ke halaman login setelah sukses verifikasi
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
            'Gagal', response['message'] ?? 'OTP salah atau sudah kedaluwarsa',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future resendOtp() async {
    if (email.value.isEmpty) {
      Get.snackbar('Gagal', 'Email tidak tersedia',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final response = await AuthService.resendOtp(email.value);

      if (response['success'] == true) {
        Get.snackbar(
            'Sukses', response['message'] ?? 'Kode OTP telah dikirim ulang',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', response['message'] ?? 'Gagal mengirim ulang OTP',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
