import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔻 Bottom Nav disesuaikan
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
                Get.offAllNamed('/dashboard');
              },
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                Get.toNamed('/about'); // 🟢 Halaman ini sendiri
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {
                Get.toNamed('/profile');
              },
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("About",
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),

              const SizedBox(height: 16),

              _buildCard(
                "Procue adalah aplikasi pelatihan untuk membantu pemain biliar meningkatkan teknik dan strategi permainan melalui analisis gerakan yang cerdas dan interaktif.",
              ),

              const SizedBox(height: 16),

              _buildCard(
                "List poin-poin fitur kunci dari aplikasi:\n"
                "1. Deteksi\n"
                "2. Kamus Billiard cerdas\n"
                "3. Tutorial dan panduan\n"
                "4. Riwayat hasil Deteksi",
              ),

              const SizedBox(height: 16),

              _buildCard(
                "Ada saran atau kendala?\nHubungi kami di:\nprocue.app@gmail.com",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
