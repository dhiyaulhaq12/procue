import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AturanPermainanView extends StatelessWidget {
  const AturanPermainanView({Key? key}) : super(key: key);

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
                    'Aturan Permainan',
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
                  _buildSectionTitle("Tujuan Permainan :"),
                  _buildBlackBox(
                      "Pemain harus memasukkan bola-bola bernomor ke dalam lubang (pocket) sesuai dengan jenis permainan yang dimainkan. Misalnya dalam 8-ball, pemain harus memasukkan semua bola solid (1–7) atau strip (9–15) sebelum memasukkan bola 8."),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Break Shot :"),
                  _buildBlackBox(
                      "Permainan dimulai dengan “break shot” di mana pemain memukul bola putih untuk menyebarkan bola-bola lain terpencar. Dalam sebagian besar aturan, minimal 4 bola harus menyentuh bantalan meja atau minimal 1 bola harus masuk ke lubang agar break dianggap sah."),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Giliran Bermain :"),
                  _buildBlackBox(
                      "Pukulan dimulai bola putih dipukul dengan stik mengarah ke kawah sehingga bola putih mengenai ke atas meja untuk memasuki bola sasaran."),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Kesalahan (Foul) :"),
                  _buildBlackBox(
                      "Kesalahan umum meliputi:\n• Bola putih masuk ke lubang (scratch).\n• Tidak mengenai bola sasaran terlebih dahulu.\n• Tidak ada satupun yang menyentuh bantalan setelah terkena bola.\nJika terjadi foul, lawan biasanya diberi bola di tangan (ball in hand) dan bisa meletakkan bola putih di mana saja di meja."),
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

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildBlackBox(String content) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
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

  Widget _buildNavIcon(IconData icon, String route) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Icon(
        icon,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
