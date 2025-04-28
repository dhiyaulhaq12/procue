import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../modules/profile/views/profile_view.dart'; // Import ProfileView

class DashboardView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Custom Bottom Navigation
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(27),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                // Logika untuk kembali ke dashboard (jika perlu)
              },
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                Get.toNamed('/about');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {
                // Navigasi ke halaman Profil lewat route GetX
                Get.toNamed('/profile');
              },
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "ProCue",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Banner image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/images/banner.jpg",
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),

                // Dot indicator placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == 0 ? Colors.green : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32), // Jarak antara banner dan grid menu

                // Grid menu
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.9, // bikin item lebih kecil
                  children: [
                    _buildMenuItem("assets/images/deteksi.jpeg", "Deteksi"),
                    _buildMenuItem("assets/images/kamus.jpg", "Kamus Billiard"),
                    _buildMenuItem("assets/images/tutorial.jpg", "Tutorial"),
                    _buildMenuItem("assets/images/riwayat.jpeg", "Riwayat"),
                  ],
                ),

                const SizedBox(height: 32), // Tambahan space bawah
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String imagePath, String label) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imagePath,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
