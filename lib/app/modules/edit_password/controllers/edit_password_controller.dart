import 'package:get/get.dart';

class EditPasswordController extends GetxController {
  Future<void> updatePassword(String currentPassword, String newPassword) async {
    // Simulasi panggil API
    await Future.delayed(Duration(seconds: 1)); // ganti dengan real API
    if (currentPassword == "123456") { // simulasi password lama benar
      Get.snackbar("Berhasil", "Password berhasil diubah");
      Get.back();
    } else {
      Get.snackbar("Gagal", "Password lama salah");
    }
  }
}
