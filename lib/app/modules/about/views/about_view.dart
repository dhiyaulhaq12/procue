import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Atas: Background Hitam + Gambar + Teks
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg_about.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tombol back dan judul
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Get.offAllNamed('/dashboard'),
                              child: const Icon(Icons.arrow_back,
                                  color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Tentang Aplikasi',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Kontainer Putih
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: const Text(
                  "Procue adalah aplikasi pelatihan untuk membantu pemain biliar meningkatkan teknik dan strategi permainan melalui analisis gerakan yang cerdas dan interaktif.\n\n"
                  "Fitur utama dalam aplikasi ini meliputi:\n"
                  "1. Latihan\n"
                  "2. Kamus Billiard cerdas\n"
                  "3. Tutorial dan panduan\n"
                  "4. Riwayat hasil Latihan\n\n"
                  "Ada saran atau kendala?\nHubungi kami di:\nprocue.app@gmail.com",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18, // ✅ DIPERBESAR DARI 16
                    height: 1.6,
                  ),
                ),
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
                height: 50,
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
}
