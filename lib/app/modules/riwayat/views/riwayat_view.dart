import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatView extends StatelessWidget {
  final controller = Get.put(RiwayatController());

  @override
  Widget build(BuildContext context) {
    controller.fetchRiwayat();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Latihan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              Get.defaultDialog(
                title: 'Hapus Semua',
                middleText: 'Yakin ingin menghapus semua riwayat?',
                textCancel: 'Batal',
                textConfirm: 'Hapus',
                confirmTextColor: Colors.white,
                onConfirm: () {
                  controller.deleteAllRiwayat();
                  Get.back();
                },
              );
            },
          )
        ],
      ),
      body: Obx(() {
        final list = controller.riwayatList;
        if (list.isEmpty) {
          return const Center(child: Text('Belum ada riwayat'));
        }

        // Hitung jumlah label
        final counts = {
          'OpenBridge': 0,
          'CloseBridge': 0,
          'RailBridge': 0,
        };
        for (var item in list) {
          final label = item['label'] ?? '';
          if (counts.containsKey(label)) {
            counts[label] = counts[label]! + 1;
          }
        }

        final total = counts.values.fold(0, (a, b) => a + b);

        return Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Distribusi Latihan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 220,
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 20,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation(Colors.blue),
                          ),
                        ),
                        if (value >= 1)
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                                sections: [
                                  PieChartSectionData(
                                    color: Colors.blue,
                                    value: counts['OpenBridge']!.toDouble(),
                                    title: total > 0
                                        ? '${(counts['OpenBridge']! / total * 100).toStringAsFixed(1)}%'
                                        : '0%',
                                    radius: 60,
                                  ),
                                  PieChartSectionData(
                                    color: Colors.yellow,
                                    value: counts['CloseBridge']!.toDouble(),
                                    title: total > 0
                                        ? '${(counts['CloseBridge']! / total * 100).toStringAsFixed(1)}%'
                                        : '0%',
                                    radius: 60,
                                  ),
                                  PieChartSectionData(
                                    color: Colors.red,
                                    value: counts['RailBridge']!.toDouble(),
                                    title: total > 0
                                        ? '${(counts['RailBridge']! / total * 100).toStringAsFixed(1)}%'
                                        : '0%',
                                    radius: 60,
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legend(Colors.blue, 'OpenBridge'),
                const SizedBox(width: 8),
                _legend(Colors.yellow, 'CloseBridge'),
                const SizedBox(width: 8),
                _legend(Colors.red, 'RailBridge'),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  final accuracy = (item['accuracy'] is num)
                      ? (item['accuracy'] as num).toStringAsFixed(1)
                      : item['accuracy'].toString();

                  String formattedDate = item['timestamp'] ?? '';
                  try {
                    final dateTime = DateTime.parse(item['timestamp']);
                    formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
                  } catch (_) {}

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: Image.network(
                        item['image_url'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item['label'] ?? 'Tidak ada label'),
                      subtitle: Text('Akurasi: $accuracy%\n$formattedDate'),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'Hapus Riwayat',
                            middleText: 'Yakin ingin menghapus riwayat ini?',
                            textCancel: 'Batal',
                            textConfirm: 'Hapus',
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              controller.deleteRiwayatById(item['id']);
                              Get.back();
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _legend(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
