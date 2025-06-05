import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RiwayatView extends StatefulWidget {
  const RiwayatView({Key? key}) : super(key: key);

  @override
  State<RiwayatView> createState() => _RiwayatViewState();
}

class _RiwayatViewState extends State<RiwayatView> {
  final List<Map<String, String>> riwayatList = [
    {
      'judul': 'Open Bridge',
      'imagePath': 'assets/images/openbridge.jpg',
      'deskripsi': 'Posisi jari sebelum memukul bola sudah tepat dan mantap.',
    },
    {
      'judul': 'Close Bridge',
      'imagePath': 'assets/images/closebridge.jpg',
      'deskripsi': 'Posisi jari saat bersiap membidik bola agar tetap stabil.',
    },
    {
      'judul': 'Rail Bridge',
      'imagePath': 'assets/images/railbridge.jpg',
      'deskripsi':
          'Posisi jari membentuk jembatan untuk menopang stik saat membidik.',
    },
  ];

  final List<bool> showDetail = [];

  @override
  void initState() {
    super.initState();
    showDetail.addAll(List.generate(riwayatList.length, (index) => false));
  }

  void toggleDetail(int index) {
    setState(() {
      showDetail[index] = !showDetail[index];
    });
  }

  void deleteItem(int index) {
    setState(() {
      riwayatList.removeAt(index);
      showDetail.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Riwayat Deteksi',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/banner.jpg',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView.builder(
                itemCount: riwayatList.length,
                itemBuilder: (context, index) {
                  final item = riwayatList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['judul']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  showDetail[index]
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),
                                onPressed: () => toggleDetail(index),
                              ),
                            ],
                          ),
                          if (showDetail[index]) ...[
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                item['imagePath']!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(item['deskripsi']!),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteItem(index),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
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
                    _buildNavIcon(
                        Icons.person_outline, '/profile', Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String route, Color color) {
    return GestureDetector(
      onTap: () {
        if (route == '/dashboard') {
          Get.offAllNamed(route);
        } else {
          Get.toNamed(route);
        }
      },
      child: Icon(icon, color: color, size: 28),
    );
  }
}
