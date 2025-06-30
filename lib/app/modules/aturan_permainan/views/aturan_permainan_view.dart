import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AturanPermainanView extends StatelessWidget {
  const AturanPermainanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Aturan Permainan'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/aturan.png', // Ganti dengan filemu
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),

          // Konten aturan permainan
          _buildSection("Tujuan Permainan", 
            "Pemain harus memasukkan bola-bola bernomor ke dalam lubang (pocket) sesuai dengan jenis permainan yang dimainkan. Misalnya dalam 8-ball, pemain harus memasukkan semua bola solid (1–7) atau strip (9–15) sebelum memasukkan bola 8."),
          
          _buildSection("Break Shot", 
            "Permainan dimulai dengan “break shot” di mana pemain memukul bola putih untuk menyebarkan bola-bola lain terpencar. Dalam sebagian besar aturan, minimal 4 bola harus menyentuh bantalan meja atau minimal 1 bola harus masuk ke lubang agar break dianggap sah."),
          
          _buildSection("Giliran Bermain", 
            "Pemain akan bergantian memukul bola putih untuk mencoba memasukkan bola sasaran sesuai giliran. Permainan berpindah jika tidak ada bola yang masuk atau terjadi foul."),
          
          _buildSection("Kesalahan (Foul)", 
            "Kesalahan umum meliputi:\n• Bola putih masuk ke lubang (scratch).\n• Tidak mengenai bola sasaran terlebih dahulu.\n• Tidak ada satupun bola menyentuh bantalan setelah kontak.\nJika foul terjadi, lawan mendapat \"ball in hand\" dan bisa meletakkan bola putih di mana saja."),
        ],
      ),
    );
  }

  // Komponen judul + kotak isi
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
