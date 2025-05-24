import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pelatihan_billiard_cerdas/app/routes/app_pages.dart'; // pastikan ini sesuai path

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplikasi Pelatihan Billiard Cerdas",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

