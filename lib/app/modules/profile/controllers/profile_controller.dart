import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final box = GetStorage();
    final authType = box.read('authType') ?? '';

    print('AuthType: $authType');

    if (authType == 'google') {
      // Ambil data dari GetStorage (login Google)
      username.value = box.read('userName') ?? '';
      email.value = box.read('userEmail') ?? '';
      print('Data Google Login berhasil di-load');
    } else {
      // Login manual via token JWT
      username.value = box.read('userName') ?? '';
      email.value = box.read('userEmail') ?? '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      print('Token dari SharedPreferences: $token');

      if (token == null) {
        Get.snackbar('Error', 'Token tidak ditemukan');
        return;
      }

      final response = await http.get(
        Uri.parse('https://backend-billiard.vercel.app/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];

        username.value = user['username'] ?? '';
        email.value = user['email'] ?? '';

        box.write('userName', user['username'] ?? '');
        box.write('userEmail', user['email'] ?? '');
        box.write('authType', 'manual');

        print('userName: ${box.read('userName')}');
        print('userEmail: ${box.read('userEmail')}');
        print('authType: ${box.read('authType')}');
      } else {
        print('Gagal ambil data: ${response.body}');
        Get.snackbar('Gagal', 'Gagal mengambil data user');
      }
    }

    print('userName: ${box.read('userName')}');
    print('userEmail: ${box.read('userEmail')}');
    print('authType: ${box.read('authType')}');
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    final box = GetStorage();

    await prefs.remove('access_token');
    await box.erase(); // Hapus semua data GetStorage

    Get.offAllNamed('/login');
  }
}
