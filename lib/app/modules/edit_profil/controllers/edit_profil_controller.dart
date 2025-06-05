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
  // final emailController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  var selectedImagePath = ''.obs;
  var profilePictureUrl = ''.obs; // Tambahkan untuk menyimpan URL foto profil

  final ImagePicker _picker = ImagePicker();

  @override
  void onReady() {
    super.onReady();
    loadSavedProfilePicture(); // Load ulang foto saat halaman ready
  }

  @override
  void onInit() {
    super.onInit();
    loadSavedProfilePicture(); // Load foto yang tersimpan dulu
    fetchUserData();
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
    isLoading.value = true;

    final box = GetStorage();
    final authType = box.read('authType') ?? '';

    if (authType == 'google') {
      usernameController.text = box.read('userName') ?? '';
      // Untuk Google auth, ambil foto dari GetStorage jika ada
      profilePictureUrl.value = box.read('profilePicture') ?? '';
    } else {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      // Ambil foto profil yang tersimpan terlebih dahulu
      final savedProfilePicture = prefs.getString('profile_picture') ?? '';
      if (savedProfilePicture.isNotEmpty) {
        profilePictureUrl.value = savedProfilePicture;
      }

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
          usernameController.text = (user['username'] ?? '').toString();
          // emailController.text = (user['email'] ?? '').toString();
          
          // Update foto profil jika ada dari server
          if (user['profile_picture'] != null && user['profile_picture'].toString().isNotEmpty) {
            profilePictureUrl.value = user['profile_picture'].toString();
            prefs.setString('profile_picture', user['profile_picture']);
          }
          
          prefs.setString('user_id', user['_id']);
        } else {
          // Get.snackbar('Gagal', 'Gagal mengambil data user');
        }
      } catch (e) {
        // Get.snackbar('Error', 'Terjadi kesalahan: $e');
      }
    }

    isLoading.value = false;
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        // Jangan reset profilePictureUrl di sini, biarkan view menangani prioritas
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
      final newUsername = usernameController.text.trim();
      if (newUsername.isNotEmpty) {
        box.write('userName', newUsername);
        // Simpan foto profil lokal untuk Google auth jika ada
        if (selectedImagePath.value.isNotEmpty) {
          box.write('profilePicture', selectedImagePath.value);
          profilePictureUrl.value = selectedImagePath.value;
        }
        Get.snackbar('Sukses', 'Profil berhasil diperbarui secara lokal');
      } else {
        Get.snackbar('Error', 'Username tidak boleh kosong');
      }
      isLoading.value = false;
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '';
    final token = prefs.getString('access_token') ?? '';

    if (token == null || userId == null) {
      Get.snackbar('Error', 'Token atau ID pengguna tidak ditemukan');
      isLoading.value = false;
      return;
    }

    final username = usernameController.text.trim();
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isNotEmpty) {
      if (oldPassword.isEmpty) {
        Get.snackbar(
            'Error', 'Password lama harus diisi untuk mengganti password');
        isLoading.value = false;
        return;
      }

      if (newPassword.isNotEmpty && newPassword != confirmPassword) {
        Get.snackbar('Error', 'Konfirmasi password tidak cocok');
        isLoading.value = false;
        return;
      }
    }

    final uri = Uri.parse('https://backend-billiard.vercel.app/$userId/update');
    var request = http.MultipartRequest('PATCH', uri);
    request.headers['Authorization'] = 'Bearer $token';

    if (username.isNotEmpty) request.fields['username'] = username;
    if (newPassword.isNotEmpty) request.fields['password'] = newPassword;
    if (newPassword.isNotEmpty) {
      request.fields['old_password'] = oldPassword; // Kirim password lama ke backend
      request.fields['password'] = newPassword;
    }

    if (selectedImagePath.value.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_picture',
        selectedImagePath.value,
      ));
    }

    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(body);
        
        // Update profile picture URL dari response
        if (data['user'] != null && data['user']['profile_picture'] != null) {
          profilePictureUrl.value = data['user']['profile_picture'];
          // Simpan ke SharedPreferences
          prefs.setString('profile_picture', data['user']['profile_picture']);
        }
        
        Get.snackbar('Sukses', 'Profil berhasil diperbarui');
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        selectedImagePath.value = ''; // Clear selected image path
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