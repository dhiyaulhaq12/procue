import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var profilePictureUrl = ''.obs; // Tambahkan untuk foto profil

  @override
  void onInit() {
    super.onInit();
    loadSavedProfilePicture(); // Load foto tersimpan dulu
    fetchUserData();
  }

  @override
  void onReady() {
    super.onReady();
    loadSavedProfilePicture(); // Load ulang foto saat halaman ready
  }

  // Method untuk memuat foto profil yang tersimpan
  Future<void> loadSavedProfilePicture() async {
    final box = GetStorage();
    final authType = box.read('authType') ?? '';

    if (authType == 'google') {
      final savedPicture = box.read('profilePicture') ?? '';
      if (savedPicture.isNotEmpty) {
        profilePictureUrl.value = savedPicture;
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final savedPicture = prefs.getString('profile_picture') ?? '';
      if (savedPicture.isNotEmpty) {
        profilePictureUrl.value = savedPicture;
      }
    }
  }

  Future<void> fetchUserData() async {
    final box = GetStorage();
    final authType = box.read('authType') ?? '';

    print('AuthType: $authType');

    if (authType == 'google') {
      // Ambil data dari GetStorage (login Google)
      username.value = box.read('userName') ?? '';
      email.value = box.read('userEmail') ?? '';
      // Foto profil sudah di-load di loadSavedProfilePicture()
      print('Data Google Login berhasil di-load');
    } else {
      // Login manual via token JWT
      username.value = box.read('userName') ?? '';
      email.value = box.read('userEmail') ?? '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      
      // Ambil foto profil yang tersimpan terlebih dahulu
      final savedProfilePicture = prefs.getString('profile_picture') ?? '';
      if (savedProfilePicture.isNotEmpty) {
        profilePictureUrl.value = savedProfilePicture;
      }

      print('Token dari SharedPreferences: $token');

      if (token == null) {
        Get.snackbar('Error', 'Token tidak ditemukan');
        return;
      }

      try {
        final response = await http.get(
          Uri.parse('https://backend-billiard.vercel.app/user'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final user = data['user'];

          username.value = user['username'] ?? '';
          email.value = user['email'] ?? '';

          // Update foto profil jika ada dari server
          if (user['profile_picture'] != null && user['profile_picture'].toString().isNotEmpty) {
            profilePictureUrl.value = user['profile_picture'].toString();
            prefs.setString('profile_picture', user['profile_picture']);
          }

          box.write('userName', user['username'] ?? '');
          box.write('userEmail', user['email'] ?? '');
          box.write('authType', 'manual');

          print('userName: ${box.read('userName')}');
          print('userEmail: ${box.read('userEmail')}');
          print('authType: ${box.read('authType')}');
          print('profile_picture: ${user['profile_picture']}');
        } else {
          print('Gagal ambil data: ${response.body}');
          Get.snackbar('Gagal', 'Gagal mengambil data user');
        }
      } catch (e) {
        print('Error fetching user data: $e');
        Get.snackbar('Error', 'Terjadi kesalahan: $e');
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