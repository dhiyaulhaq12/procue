import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KamusBilliardView extends StatelessWidget {
  const KamusBilliardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Kamus Billiard'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFB3E5FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: const [
              KamusCard(
                title: 'Teknik Pukulan',
                description: 'Berbagai teknik dasar dan lanjutan dalam bermain billiard.',
                imagePath: 'assets/images/teknik.jpg',
                routeName: '/teknik_pukulan',
              ),
              SizedBox(height: 16),
              KamusCard(
                title: 'Peralatan',
                description: 'Macam-macam peralatan yang digunakan dalam permainan billiard.',
                imagePath: 'assets/images/peralatan.jpg',
                routeName: '/peralatan',
              ),
              SizedBox(height: 16),
              KamusCard(
                title: 'Aturan Permainan',
                description: 'Panduan aturan resmi dalam permainan billiard.',
                imagePath: 'assets/images/aturan.png',
                routeName: '/aturan_permainan',
              ),
              SizedBox(height: 16),
              KamusCard(
                title: 'Jenis Permainan',
                description: 'Variasi permainan billiard seperti 8-ball, 9-ball, dll.',
                imagePath: 'assets/images/jenis.jpg',
                routeName: '/jenis_permainan',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KamusCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String routeName;

  const KamusCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(routeName),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 280,
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
                    onPressed: () => Get.toNamed(routeName),
                    child: const Text('Lihat Detail'),
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
