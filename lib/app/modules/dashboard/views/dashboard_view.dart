import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Welcome Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Welcome,",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "ProCue Apps",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Container Putih
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "MY FITURE",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.8, // Ukuran grid diperbaiki sedikit
                              children: [
                                _buildMenuItem("assets/images/deteksi.jpeg", "Deteksi"),
                                _buildMenuItem("assets/images/kamus.jpg", "Kamus Billiard"),
                                _buildMenuItem("assets/images/tutorial.jpg", "Tutorial"),
                                _buildMenuItem("assets/images/riwayat.jpeg", "Riwayat"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Bottom Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(27),
              child: Container(
                height: 70,
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavIcon(Icons.home, '/dashboard', Colors.white),
                    _buildNavIcon(Icons.info_outline, '/about', Colors.white),
                    _buildNavIcon(Icons.person_outline, '/profile', Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Icon Navigasi
  Widget _buildNavIcon(IconData icon, String route, Color iconColor) {
    return GestureDetector(
      onTap: () {
        if (route == '/dashboard') {
          Get.offAllNamed(route);
        } else {
          Get.toNamed(route);
        }
      },
      child: Icon(
        icon,
        color: iconColor,
        size: 28,
      ),
    );
  }

  // Widget untuk Menu Atas
  Widget _buildMenuItem(String imagePath, String label) {
    double extraSpacing = (label == "Deteksi" || label == "Kamus Billiard") ? 24 : 14;
    
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imagePath,
            width: 110, // Lebih besar lagi dari sebelumnya
            height: 110,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: extraSpacing), // Extra spacing lebih besar
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14, // Tambahan: sedikit lebih besar font-nya
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
