import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilController extends GetxController {
  final usernameController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  var selectedImagePath = ''.obs; // path gambar yang dipilih user

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    isLoading.value = true;

    final box = GetStorage();
    final authType = box.read('authType') ?? '';

    if (authType == 'google') {
      // Login via Google - ambil data dari local storage
      usernameController.text = box.read('userName') ?? '';
      // Jika ingin load foto profil Google bisa tambahkan disini
    } else {
      // Login via backend - ambil data dari API
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Token tidak ditemukan, silakan login ulang');
        isLoading.value = false;
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
          usernameController.text = user['username'] ?? '';

          // Simpan user ID ke SharedPreferences (penting untuk update)
          prefs.setString('user_id', user['_id']);

          // Jika backend mengirim URL foto profil, bisa simpan path ini atau simpan di observable
          // contoh:
          // selectedImagePath.value = user['profile_photo_url'] ?? '';
        } else {
          print('Gagal ambil data user: ${response.body}');
          Get.snackbar('Gagal', 'Gagal mengambil data user');
        }
      } catch (e) {
        Get.snackbar('Error', 'Terjadi kesalahan: $e');
      }
    }

    isLoading.value = false;
  }

  // Fungsi untuk pilih gambar dari gallery
  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  void updateProfile() async {
    final box = GetStorage();
    final authType = box.read('authType') ?? '';
    isLoading.value = true;

    if (authType == 'google') {
      // Update lokal untuk login Google
      final newUsername = usernameController.text.trim();
      if (newUsername.isNotEmpty) {
        box.write('userName', newUsername);
        Get.snackbar('Sukses', 'Profil berhasil diperbarui secara lokal');
      } else {
        Get.snackbar('Error', 'Username tidak boleh kosong');
      }
      isLoading.value = false;
      return;
    }

    // Update untuk user non-Google
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final userId = prefs.getString('user_id');

    if (token == null || userId == null) {
      Get.snackbar('Error', 'Token atau ID pengguna tidak ditemukan');
      isLoading.value = false;
      return;
    }

    final username = usernameController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isNotEmpty && newPassword != confirmPassword) {
      Get.snackbar('Error', 'Konfirmasi password tidak cocok');
      isLoading.value = false;
      return;
    }

    final uri = Uri.parse('https://backend-billiard.vercel.app/$userId/update');
    var request = http.MultipartRequest('PATCH', uri);
    request.headers['Authorization'] = 'Bearer $token';

    if (username.isNotEmpty) request.fields['username'] = username;
    if (newPassword.isNotEmpty) request.fields['password'] = newPassword;

    // Jika user pilih foto baru, tambahkan file foto ke request
    if (selectedImagePath.value.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture', // nama field untuk foto di backend, sesuaikan jika berbeda
          selectedImagePath.value,
        ),
      );
    }

    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Get.snackbar('Sukses', 'Profil berhasil diperbarui');
        newPasswordController.clear();
        confirmPasswordController.clear();

        // Reset image path jika sudah berhasil update
        selectedImagePath.value = '';
      } else {
        final data = jsonDecode(body);
        Get.snackbar('Gagal', data['message'] ?? 'Gagal memperbarui profil');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    usernameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
