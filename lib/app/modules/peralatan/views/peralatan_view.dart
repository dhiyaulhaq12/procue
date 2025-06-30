import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PeralatanView extends StatelessWidget {
  PeralatanView({Key? key}) : super(key: key); // ← TANPA `const` agar hot reload bisa

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Peralatan'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner gambar atas
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/peralatan.jpg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),

          // Konten per bagian
          _buildSection(
            "Stick Cue",
            "Tongkat panjang yang digunakan untuk memukul bola. Terbuat dari kayu atau serat karbon. Ada berbagai jenis cue seperti:\n\n"
            "• Break Cue: khusus untuk pukulan pertama.\n"
            "• Jump Cue: khusus untuk membuat bola meloncat.\n"
            "• Playing Cue: cue biasa untuk pukulan umum.",
          ),

          _buildSection(
            "Chalk",
            "Kapur khusus yang digosokkan ke ujung cue (cue tip) sebelum memukul bola. Membantu menciptakan gesekan agar tidak terjadi slip dan meningkatkan akurasi.",
          ),

          _buildSection(
            "Glove",
            "Digunakan pada tangan yang menyentuh cue agar pergerakan cue lebih halus dan tidak terganggu oleh keringat. Membantu kestabilan pukulan.",
          ),

          _buildSection(
            "Rack",
            "Alat berbentuk segitiga (untuk 8-ball) atau berlian (untuk 9-ball) yang digunakan untuk merapikan posisi bola sebelum break shot.",
          ),

          _buildSection(
            "Ball",
            "Bola biliar biasanya berdiameter sekitar 57 mm. Ada bola bernomor 1–15 dan bola putih (cue ball). Bola solid (1–7) dan strip (9–15) digunakan dalam permainan 8-ball.",
          ),

          _buildSection(
            "Table",
            "Meja persegi panjang yang dilapisi kain (biasanya hijau atau biru) dengan 6 lubang (pocket). Ukuran standar adalah 9 kaki, tetapi ada juga ukuran 7 dan 8 kaki.",
          ),
        ],
      ),
    );
  }

  // Fungsi pembentuk section
  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title :",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
