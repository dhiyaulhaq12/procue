import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/teknik_pukulan_controller.dart';

class TeknikPukulanView extends GetView<TeknikPukulanController> {
  const TeknikPukulanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // background abu muda
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Teknik Pukulan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Garis pembatas
            const Divider(thickness: 1),

            // Daftar teknik pukulan
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    TeknikCard(
                      title: 'Stun Shot',
                      description:
                          'Pukulan di mana bola putih dipukul tanpa putaran sehingga langsung berhenti begitu mengenai bola sasaran',
                    ),
                    TeknikCard(
                      title: 'Follow Shot',
                      description:
                          'Pukulan di mana bola putih diberi putaran maju (topspin) sehingga setelah mengenai bola sasaran, bola putih terus bergerak ke depan.',
                    ),
                    TeknikCard(
                      title: 'Draw Shot',
                      description:
                          'Pukulan di mana bola putih diberi putaran mundur (backspin) sehingga setelah mengenai bola sasaran, bola putih bergerak mundur ke belakang.',
                    ),
                    TeknikCard(
                      title: 'Jump Shot',
                      description:
                          'Pukulan di mana bola putih dipukul dengan stik mengarah ke bawah sehingga bola putih melompat ke atas meja untuk melewati bola penghalang.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Padding(
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
                _buildNavIcon(Icons.home, '/dashboard', Colors.white),
                _buildNavIcon(Icons.info_outline, '/about', Colors.white),
                _buildNavIcon(Icons.person_outline, '/profile', Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String route, Color iconColor) {
    return GestureDetector(
      onTap: () {
        if (route == '/dashboard') {
          Get.offAllNamed(route);
        } else {
          Get.toNamed(route);
        }
      },
      child: Icon(
        icon,
        color: iconColor,
        size: 28,
      ),
    );
  }
}

// Widget untuk menampilkan teknik pukulan
class TeknikCard extends StatelessWidget {
  final String title;
  final String description;

  const TeknikCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
