import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
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

    final platform = await getPlatformInfo();
    final box = GetStorage();
    box.write('deviceInfo', platform); // ✅ Simpan info device untuk logout

    final response = await AuthService.login(email, password, platform);

    final accessToken = response['access_token'];
    final userId = response['user_id'];
    final username = response['username'];

    print("Login Response: $response");

    if (response['success'] == true &&
        accessToken is String &&
        userId is String &&
        username is String) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('user_id', userId);
      await prefs.setString('username', username);

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

  // ✅ Login dengan Google (disesuaikan)
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn =
          GoogleSignIn(scopes: ['email', 'profile']);
      await googleSignIn.signOut(); // Optional: logout sesi sebelumnya
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("Login Google dibatalkan pengguna");
        Get.snackbar("Login Dibatalkan", "Pengguna membatalkan login Google.");
        return;
      }

      final platform = await getPlatformInfo();
      final box = GetStorage();
      box.write('deviceInfo', platform); // ✅ Simpan info device untuk logout

      // 🔄 Kirim data login Google ke backend untuk simpan login_logs & dapatkan token
      final response = await AuthService.loginGoogle(
        googleUser.email,
        googleUser.displayName ?? 'Pengguna Google',
        platform,
      );

      print("Login Google Backend Response: $response");

      if (response['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        final accessToken = response['access_token'];
        final userId = response['user_id'];
        final username = response['username'];

        await prefs.setString('access_token', accessToken);
        await prefs.setString('user_id', userId);
        await prefs.setString('username', username);

        box.write('access_token', accessToken);
        box.write('user_id', userId);
        box.write('username', username);
        box.write('authType', 'google');
        box.write('userName', username);

        // 🔥 Tambahan penting: simpan email & foto profil
        box.write('userEmail', googleUser.email);
        box.write('profilePicture', googleUser.photoUrl ?? '');

        print("Login Google berhasil: ${googleUser.email}");

        Get.snackbar("Sukses", "Login Google berhasil");
        Get.offAllNamed('/dashboard');
      } else {
        Get.snackbar(
            "Login Gagal", response['message'] ?? 'Gagal login Google');
      }
    } catch (e) {
      print("Error saat login Google: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat login: $e");
    }
  }

  Future<String> getPlatformInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return '${androidInfo.brand} ${androidInfo.model}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return '${iosInfo.name} ${iosInfo.model}';
    }
    return 'unknown device';
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
