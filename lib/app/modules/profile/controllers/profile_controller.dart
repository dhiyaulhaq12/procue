import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class ProfileController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var profilePictureUrl = ''.obs;
  var authType = ''.obs;

  final String baseUrl = 'https://backend-billiard.vercel.app';

  @override
  final box = GetStorage(); // agar bisa dipakai langsung di view

  void onInit() {
    super.onInit();
    loadSavedProfilePicture();
    fetchUserData();
  }

  @override
  void onReady() {
    super.onReady();
    loadSavedProfilePicture();
  }

  // Method untuk mendapatkan informasi device
  Future<String> getDeviceInfo() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.brand} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return '${iosInfo.name} ${iosInfo.model}';
      } else {
        return 'Unknown Device';
      }
    } catch (e) {
      print('Error getting device info: $e');
      return 'Unknown Device';
    }
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
    authType.value = box.read('authType') ?? '';

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
          Uri.parse('$baseUrl/user'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final user = data['user'];

          username.value = user['username'] ?? '';
          email.value = user['email'] ?? '';

          // Update foto profil jika ada dari server
          if (user['profile_picture'] != null &&
              user['profile_picture'].toString().isNotEmpty) {
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

  // Method logout yang lengkap dengan API call
  void logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final box = GetStorage();

      final token = prefs.getString('access_token') ?? box.read('access_token');
      final authType = box.read('authType') ?? '';
      String deviceInfo = box.read('deviceInfo') ?? 'unknown';

      if (deviceInfo == 'unknown') {
        deviceInfo = await getDeviceInfo();
      }

      // Tetap kirim request logout ke backend, baik login manual atau Google
      if (token != null) {
        try {
          final response = await http.post(
            Uri.parse('$baseUrl/logout'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'platform': deviceInfo}),
          );

          print('Device Info: $deviceInfo');
          print('Logout API response: ${response.statusCode}');
          print('Logout API body: ${response.body}');

          if (response.statusCode == 200) {
            print('Logout berhasil dicatat di backend');
          } else {
            print('Logout API gagal: ${response.body}');
          }
        } catch (apiError) {
          print('Error calling logout API: $apiError');
        }
      }

      // Hapus data lokal
      await prefs.remove('access_token');
      await prefs.remove('profile_picture');
      await box.erase();

      Get.offAllNamed('/login');
      Get.snackbar(
        'Berhasil',
        'Logout berhasil',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print('Error during logout: $e');
      // Fallback logout offline
      final prefs = await SharedPreferences.getInstance();
      final box = GetStorage();
      await prefs.remove('access_token');
      await prefs.remove('profile_picture');
      await box.erase();

      Get.offAllNamed('/login');
      Get.snackbar(
        'Peringatan',
        'Logout berhasil (offline)',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }
}
