import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class LoginActivityController extends GetxController {
  var isLoading = true.obs;
  var activityLogs = [].obs;
  var isDeleting = false.obs;

  @override
  void onInit() {
    fetchLoginLogs();
    super.onInit();
  }

  void fetchLoginLogs() async {
    try {
      isLoading.value = true;
      
      // Inisialisasi ulang GetStorage untuk memastikan data terbaca
      await GetStorage.init();
      final box = GetStorage();
      
      // Cek jenis auth terlebih dahulu
      final authType = box.read('authType');
      print('=== DEBUG ACTIVITY CONTROLLER ===');
      print('Auth Type: $authType');
      
      if (authType == 'google') {
        // Untuk Google login, tidak ada activity logs dari backend
        print('Google login detected - no backend activity logs available');
        activityLogs.value = [];
        Get.snackbar(
          'Info', 
          'Activity logs hanya tersedia untuk login manual',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      
      // Ambil token menggunakan key 'access_token' sesuai login controller
      final token = box.read('access_token');
      final userId = box.read('user_id');
      final username = box.read('username');
      
      print('Access Token: $token');
      print('User ID: $userId');
      print('Username: $username');
      print('Token null?: ${token == null}');
      print('Token empty?: ${token?.isEmpty}');
      
      if (token == null || token.isEmpty) {
        print('Access token tidak ditemukan, menampilkan snackbar...');
        Get.snackbar(
          'Error', 
          'Token tidak ditemukan. Silakan login ulang.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      print('Mengirim request ke server...');
      final response = await http.get(
        Uri.parse('https://backend-billiard.vercel.app/activity'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['logs'] != null) {
          activityLogs.value = jsonData['logs'];
          print('Data logs berhasil dimuat: ${jsonData['logs'].length} items');
          Get.snackbar(
            'Success', 
            'Data aktivitas berhasil dimuat',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          activityLogs.value = [];
          Get.snackbar(
            'Info', 
            'Tidak ada data aktivitas',
            snackPosition: SnackPosition.TOP,
          );
        }
      } else if (response.statusCode == 401) {
        print('Token expired atau tidak valid');
        Get.snackbar(
          'Error', 
          'Token tidak valid. Silakan login ulang.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // Optional: redirect ke halaman login
        // Get.offAllNamed('/login');
      } else if (response.statusCode == 422) {
        final errorData = json.decode(response.body);
        print('Error 422: ${errorData}');
        Get.snackbar(
          'Error', 
          'Error 422: ${errorData['message'] ?? 'Data tidak valid'}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        print('Server error: ${response.statusCode}');
        Get.snackbar(
          'Error', 
          'Gagal mengakses server: ${response.statusCode}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      print('Loading selesai');
    }
  }

  // Method untuk delete single activity log
  Future<void> deleteActivityLog(String logId, int index) async {
    try {
      isDeleting.value = true;
      
      final box = GetStorage();
      final token = box.read('access_token');
      
      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Error', 
          'Token tidak ditemukan. Silakan login ulang.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      print('Menghapus activity log ID: $logId');
      final response = await http.delete(
        Uri.parse('https://backend-billiard.vercel.app/activity/$logId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Delete Response Status Code: ${response.statusCode}');
      print('Delete Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Hapus dari list lokal
        activityLogs.removeAt(index);
        Get.snackbar(
          'Success', 
          'Log aktivitas berhasil dihapus',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Error', 
          'Token tidak valid. Silakan login ulang.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (response.statusCode == 404) {
        Get.snackbar(
          'Error', 
          'Log aktivitas tidak ditemukan',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        final errorData = json.decode(response.body);
        Get.snackbar(
          'Error', 
          'Gagal menghapus log: ${errorData['message'] ?? 'Error ${response.statusCode}'}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Exception saat delete: $e');
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  // Method untuk delete all activity logs
  Future<void> deleteAllActivityLogs() async {
    try {
      isDeleting.value = true;
      
      final box = GetStorage();
      final token = box.read('access_token');
      
      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Error', 
          'Token tidak ditemukan. Silakan login ulang.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      print('Menghapus semua activity logs');
      final response = await http.delete(
        Uri.parse('https://backend-billiard.vercel.app/activity/all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Delete All Response Status Code: ${response.statusCode}');
      print('Delete All Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Clear list lokal
        activityLogs.clear();
        Get.snackbar(
          'Success', 
          'Semua log aktivitas berhasil dihapus',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Error', 
          'Token tidak valid. Silakan login ulang.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        final errorData = json.decode(response.body);
        Get.snackbar(
          'Error', 
          'Gagal menghapus semua log: ${errorData['message'] ?? 'Error ${response.statusCode}'}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Exception saat delete all: $e');
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  // Method untuk show confirmation dialog
  void showDeleteConfirmation(String logId, int index, String platform) {
    Get.dialog(
      AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus log aktivitas dari $platform?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => {
              Get.back(),
              deleteActivityLog(logId, index),
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Method untuk show delete all confirmation dialog
  void showDeleteAllConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text('Konfirmasi Hapus Semua'),
        content: Text('Apakah Anda yakin ingin menghapus SEMUA log aktivitas?\n\nTindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteAllActivityLogs();
            },
            child: Text('Hapus Semua', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Method untuk refresh data
  void refreshData() {
    print('Refresh data dipanggil');
    fetchLoginLogs();
  }

  // Method untuk debug storage
  void debugStorage() {
    final box = GetStorage();
    print('=== DEBUG STORAGE ===');
    print('All keys: ${box.getKeys()}');
    print('Access Token: ${box.read('access_token')}');
    print('User ID: ${box.read('user_id')}');
    print('Username: ${box.read('username')}');
    print('Auth Type: ${box.read('authType')}');
    print('User Email (Google): ${box.read('userEmail')}');
    print('User Name (Google): ${box.read('userName')}');
  }

  // Method untuk clear storage (jika diperlukan)
  void clearStorage() {
    final box = GetStorage();
    box.erase();
    print('Storage cleared');
  }
}