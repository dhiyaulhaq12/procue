import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeteksiView extends StatelessWidget {
  const DeteksiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Pilih Teknik Bridge'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 255, 255), Color(0xFFB3E5FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: ListView(
            children: [
              BridgeCard(
                title: 'Open Bridge',
                description:
                    'Teknik standar untuk pukulan lurus dan kontrol bola.',
                imagePath: 'assets/images/openbridge.jpg',
                onTap: () {
                  print('OpenBridge tapped');
                  Get.toNamed('/open-bridge');
                },
              ),
              const SizedBox(height: 16),
              BridgeCard(
                title: 'Close Bridge',
                description:
                    'Cocok untuk stabilitas tinggi saat pukulan keras.',
                imagePath: 'assets/images/closebridge.jpg',
                onTap: () => Get.toNamed('/close-bridge'),
              ),
              const SizedBox(height: 16),
              BridgeCard(
                title: 'Rail Bridge',
                description: 'Digunakan saat bola dekat dengan sisi meja.',
                imagePath: 'assets/images/railbridge.jpg',
                onTap: () => Get.toNamed('/rail-bridge'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BridgeCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback onTap;

  const BridgeCard({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias, // agar gambar mengikuti radius
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar besar di atas
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onTap,
                    child: const Text('Pelajari Lebih Lanjut'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepOrange,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
