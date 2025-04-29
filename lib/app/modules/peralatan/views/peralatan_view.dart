import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/peralatan_controller.dart';

class PeralatanView extends GetView<PeralatanController> {
  const PeralatanView({Key? key}) : super(key: key);

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
                    'Peralatan',
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
                  _buildSectionTitle('Stick Cue :'),
                  _buildBlackBox(
                    'Tongkat panjang yang digunakan untuk memukul bola. Terbuat dari kayu atau serat karbon. Ada berbagai jenis cue seperti:\n\n'
                    '• Break Cue: khusus untuk pukulan pertama.\n'
                    '• Jump Cue: khusus untuk membuat bola meloncat.\n'
                    '• Playing Cue: cue biasa untuk pukulan umum.',
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Chalk :'),
                  _buildBlackBox(
                    'Kapur khusus yang digosokkan ke cue tip sebelum memukul bola. Membantu menghasilkan gesekan agar bola tidak slip saat dipukul.',
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
