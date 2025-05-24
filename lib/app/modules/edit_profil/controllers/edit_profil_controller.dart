import 'package:get/get.dart';

class EditProfilController extends GetxController {
  var username = ''.obs;

  Future<void> updateUsername(String newUsername) async {
    // Panggil API update username di sini
    await Future.delayed(Duration(seconds: 1)); // simulasi API
    username.value = newUsername;
    Get.snackbar("Berhasil", "Username berhasil diubah");
    Get.back();
  }
}
