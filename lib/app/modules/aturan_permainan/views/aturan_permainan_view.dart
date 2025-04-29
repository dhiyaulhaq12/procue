import 'package:flutter/material.dart';

class AturanPermainanView extends StatelessWidget {
  const AturanPermainanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Aturan Permainan',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: "Tujuan Permainan :",
              content:
                  "Pemain harus memasukkan bola-bola bernomor ke dalam lubang (pocket) sesuai dengan jenis permainan yang dimainkan. Misalnya dalam 8-ball, pemain harus memasukkan semua bola solid (1–7) atau strip (9–15) sebelum memasukkan bola 8.",
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: "Break Shot :",
              content:
                  "Permainan dimulai dengan “break shot” di mana pemain memukul bola putih untuk menyebarkan bola-bola lain terpencar. Dalam sebagian besar aturan, minimal 4 bola harus menyentuh bantalan meja atau minimal 1 bola harus masuk ke lubang agar break dianggap sah.",
            ),
            const SizedBox(height: 16),
            const Text(
              "Giliran Bermain :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildPlainCard(
              content:
                  "Pukulan dimulai bola putih dipukul dengan stik mengarah ke kawah sehingga bola putih mengenai ke atas meja untuk memasuki bola sasaran.",
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: "Kesalahan (Foul) :",
              content:
                  "Kesalahan umum meliputi:\n• Bola putih masuk ke lubang (scratch).\n• Tidak mengenai bola sasaran terlebih dahulu.\n• Tidak ada satupun yang menyentuh bantalan setelah terkena bola.\nJika terjadi foul, lawan biasanya diberi bola di tangan (ball in hand) dan bisa meletakkan bola putih di mana saja di meja.",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.home, color: Colors.white),
              Icon(Icons.info_outline, color: Colors.white),
              Icon(Icons.person_outline, color: Colors.white),
            ],
          ),
        ),
      ),
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
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _buildPlainCard(content: content),
      ],
    );
  }

  Widget _buildPlainCard({required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(4, 4),
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
