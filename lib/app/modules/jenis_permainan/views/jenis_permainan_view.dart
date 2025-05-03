import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JenisPermainanView extends StatelessWidget {
  const JenisPermainanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: const [
                  Text(
                    'Jenis Permainan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1),

            // Konten
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSection(
                    title: "8 Ball Pool :",
                    content:
                        "Dua pemain bertanding untuk memasukkan semua bola dari kelompoknya: bola solid (nomor 1–7) atau stripe (nomor 9–15), lalu terakhir memasukkan bola 8 untuk memenangkan pertandingan.",
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    title: "9 Ball Pool :",
                    content:
                        "Permainan dimulai dengan “break shot” di mana pemain memukul bola putih untuk menyebarkan bola-bola lain terpencar. Dalam sebagian besar aturan, minimal 4 bola harus menyentuh bantalan meja atau minimal 1 bola harus masuk ke lubang agar break dianggap sah.",
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    title: "10 Ball Pool :",
                    content:
                        "Mirip dengan 9 Ball, tetapi dimainkan dengan bola 1–10 dan lebih ketat: pemain harus menyebutkan (declare) bola dan lubang tujuan sebelum melakukan tembakan.",
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    title: "Snooker :",
                    content:
                        "Pukulan di mana bola putih dipukul dengan stik mengarah ke bawah sehingga bola putih melompat ke atas meja untuk melewati bola penghalang.",
                  ),
                ],
              ),
            ),

            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(27),
                child: Container(
                  height: 70,
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavIcon(Icons.home, '/dashboard'),
                      _buildNavIcon(Icons.info_outline, '/about'),
                      _buildNavIcon(Icons.person_outline, '/profile'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        if (route == '/dashboard') {
          Get.offAllNamed(route);
        } else {
          Get.toNamed(route);
        }
      },
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        _buildBlackBox(content),
      ],
    );
  }

  Widget _buildBlackBox(String content) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(4, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        content,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
