import 'package:flutter/material.dart';

class JenisPermainanView extends StatelessWidget {
  const JenisPermainanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Jenis Permainan',
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
              title: "8 Ball Pool :",
              content:
                  "Dua pemain bertanding untuk memasukkan semua bola dari kelompoknya: bola solid (nomor 1–7) atau stripe (nomor 9–15), lalu terakhir memasukkan bola 8 untuk memenangkan pertandingan.",
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: "9 Ball Pool :",
              content:
                  "Permainan dimulai dengan “break shot” di mana pemain memukul bola putih untuk menyebarkan bola-bola lain terpencar. Dalam sebagian besar aturan, minimal 4 bola harus menyentuh bantalan meja atau minimal 1 bola harus masuk ke lubang agar break dianggap sah.",
            ),
            const SizedBox(height: 16),
            const Text(
              "10 Ball Pool :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildPlainCard(
              content:
                  "Mirip dengan 9 Ball, tetapi dimainkan dengan bola 1–10 dan lebih ketat: pemain harus menyebutkan (declare) bola dan lubang tujuan sebelum melakukan tembakan.",
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: "Snooker :",
              content:
                  "Pukulan di mana bola putih dipukul dengan stik mengarah ke bawah sehingga bola putih melompat ke atas meja untuk melewati bola penghalang.",
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
