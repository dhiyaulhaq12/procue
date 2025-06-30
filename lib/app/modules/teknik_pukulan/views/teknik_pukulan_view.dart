import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/teknik_pukulan_controller.dart';

class TeknikPukulanView extends GetView<TeknikPukulanController> {
  TeknikPukulanView({Key? key}) : super(key: key);

  final List<Map<String, String>> teknikList = [
    {
      'title': 'Stun Shot:',
      'description':
          'Pukulan di mana bola putih dipukul tanpa putaran sehingga langsung berhenti begitu mengenai bola sasaran.',
    },
    {
      'title': 'Follow Shot:',
      'description':
          'Bola putih diberi putaran maju (topspin), sehingga setelah menyentuh bola sasaran, bola putih tetap melaju ke depan.',
    },
    {
      'title': 'Draw Shot:',
      'description':
          'Pukulan di mana bola putih diberi backspin sehingga bola putih mundur setelah menyentuh bola sasaran.',
    },
    {
      'title': 'Jump Shot:',
      'description':
          'Pukulan di mana bola putih dilompatkan agar bisa melewati bola lain untuk menyentuh bola target.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Teknik Pukulan'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🖼️ Gambar banner di atas
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/teknik.jpg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),

          // 🔤 Judul + daftar teknik
          ...teknikList.map((teknik) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teknik['title'] ?? '',
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
                    teknik['description'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
