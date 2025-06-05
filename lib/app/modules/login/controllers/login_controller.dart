import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../services/auth_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Login manual (email dan password)
  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Gagal', 'Email dan password wajib diisi');
      return;
    }

    final response = await AuthService.login(email, password);

    // Ambil nilai-nilai dari response
    final accessToken = response['access_token'];
    final userId = response['user_id'];
    final username = response['username'];

    // Debug print untuk melihat respons dari backend
    print("Login Response: $response");

    // Cek apakah respons valid dan semua nilai bertipe String
    if (response['success'] == true &&
        accessToken is String &&
        userId is String &&
        username is String) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('user_id', userId);
      await prefs.setString('username', username);

      final box = GetStorage();
      box.write('access_token', accessToken);
      box.write('user_id', userId);
      box.write('username', username);
      box.write('authType', 'manual');

      print('Token after login saved: ${prefs.getString('access_token')}');
      Get.snackbar('Sukses', response['message']);
      Get.offNamed('/dashboard');
    } else {
      print("Login response tidak valid: $response");
      Get.snackbar('Login Gagal', response['message'] ?? 'Terjadi kesalahan');
    }
  }

  // Login dengan Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      await googleSignIn.signOut(); // Optional: logout sebelumnya
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("Login Google dibatalkan pengguna");
        Get.snackbar("Login Dibatalkan", "Pengguna membatalkan login Google.");
        return;
      }

      // Simpan data ke GetStorage dengan struktur yang sama seperti login API
      final box = GetStorage();
      box.write('userName', googleUser.displayName);
      box.write('userEmail', googleUser.email);
      box.write('profilePicture', googleUser.photoUrl); // ✅ simpan foto
      box.write('userPassword', '*******'); // Kosong karena Google login
      box.write('authType', 'google'); // Buat pembeda

      print("Login sukses: ${googleUser.displayName} (${googleUser.email})");

      Get.snackbar("Sukses", "Login Google berhasil");

      // Navigasi ke halaman utama
      Get.offAllNamed('/dashboard');
    } catch (e) {
      print("Error saat login Google: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat login: $e");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
