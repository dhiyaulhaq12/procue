import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pelatihan_billiard_cerdas/app/routes/app_pages.dart';
import 'firebase_options.dart';  // import file ini

// Tambahkan import LoginController
import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/login/controllers/login_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Tambahkan controller login sebagai permanent
  Get.put(LoginController(), permanent: true);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplikasi Pelatihan Billiard Cerdas",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
