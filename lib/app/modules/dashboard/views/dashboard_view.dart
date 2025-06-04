import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DashboardView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Atas: Welcome Text dan Banner
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: Text(
                    'Welcome,\nProCue Apps',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/banner.jpg',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),

          // ✅ Lottie tetap di bg hitam
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Get.toNamed('/statistik');
              },
              child: SizedBox(
                height: 80,
                width: 80,
                child: Lottie.asset(
                  'assets/lottie/statistikbar.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Kontainer putih seperti sebelumnya
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
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
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                      children: [
                        _buildMenuItem("assets/images/deteksi.jpeg", "Deteksi",
                            () {
                          Get.toNamed('/deteksi');
                        }),
                        _buildMenuItem(
                            "assets/images/kamus.jpg", "Kamus Billiard", () {
                          Get.toNamed('/kamus-biliard');
                        }),
                        _buildMenuItem("assets/images/tutorial.jpg", "Tutorial",
                            () {
                          Get.toNamed('/tutorial');
                        }),
                        _buildMenuItem("assets/images/riwayat.jpeg", "Riwayat",
                            () {
                          Get.toNamed('/riwayat');
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation
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
                    _buildNavIcon(
                        Icons.person_outline, '/profile', Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String route, Color color) {
    return GestureDetector(
      onTap: () {
        if (route == '/dashboard') {
          Get.offAllNamed(route);
        } else {
          Get.toNamed(route);
        }
      },
      child: Icon(icon, color: color, size: 28),
    );
  }
}
