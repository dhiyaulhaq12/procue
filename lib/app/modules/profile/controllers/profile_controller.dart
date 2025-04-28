import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Data dummy profil
  final email = 'rezarahardian@gmail.com'.obs;
  final name = 'Reza Rahardian'.obs;

  // Fungsi logout
  void logout() {
    // Di sini kamu bisa hapus data dari SharedPreferences atau simpanan lokal lainnya jika diperlukan
    // Misal:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    // Navigasi ke halaman login dan hapus history agar tidak bisa back
    Get.offAllNamed('/login');
  }
}
