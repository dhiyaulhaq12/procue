import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JenisPermainanView extends StatelessWidget {
  const JenisPermainanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Jenis Permainan'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Gambar banner
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/jenis.jpg',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),

          // Konten
          _buildSection(
            title: "8 Ball Pool",
            content:
                "Dua pemain bertanding untuk memasukkan semua bola dari kelompoknya: bola solid (1–7) atau stripe (9–15), lalu memasukkan bola 8 untuk menang.",
          ),
          _buildSection(
            title: "9 Ball Pool",
            content:
                "Dimainkan dengan bola 1–9. Bola harus dipukul berurutan dimulai dari bola bernomor terkecil. Pemain menang jika berhasil memasukkan bola 9 secara sah.",
          ),
          _buildSection(
            title: "10 Ball Pool",
            content:
                "Seperti 9-ball tapi lebih sulit. Pemain harus menyebut bola dan lubang tujuan sebelum memukul. Digunakan dalam banyak turnamen profesional.",
          ),
          _buildSection(
            title: "Snooker",
            content:
                "Permainan strategi tinggi dengan bola merah dan warna. Pemain bergantian memasukkan bola merah dan warna secara bergantian untuk mendapat poin tertinggi.",
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title :",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
