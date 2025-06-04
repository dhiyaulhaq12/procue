import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/statistik_controller.dart';
import 'package:collection/collection.dart';
import 'package:url_launcher/url_launcher.dart';

class StatistikView extends StatelessWidget {
  final StatistikController controller = Get.put(StatistikController());

  // Tambahkan observable untuk kontrol tampilan data
  final RxInt displayLimit = 5.obs;
  final RxBool showAll = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // <-- background hitam
      appBar: AppBar(
        title: Text('Statistik Data Billiard Youtube'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.videoList.isEmpty) {
          return Center(child: Text('Tidak ada data video.'));
        }

        // Hitung top 10 channel
        final top10 = controller.getTop10ChannelCount();

        final colors = [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.orange,
          Colors.purple,
          Colors.teal,
          Colors.brown,
          Colors.pink,
          Colors.indigo,
          Colors.cyan,
        ];

        List<PieChartSectionData> generateSections(
            Map<String, int> topChannels) {
          return topChannels.entries.mapIndexed((index, entry) {
            return PieChartSectionData(
              color: colors[index % colors.length],
              value: entry.value.toDouble(),
              showTitle: false,
              radius: 50,
            );
          }).toList();
        }

        // Ambil list data video sesuai limit
        final limitedList = showAll.value
            ? controller.videoList
            : controller.videoList.take(displayLimit.value).toList();

        final topWords = controller.getTopWords();

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFB3E5FC),
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 24),

                // Bar Chart Top Kata yang Sering Muncul
                Text(
                  "Grafik Frekuensi Top 10 Kata",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                Container(
                  height: 250,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: topWords.values.isNotEmpty
                          ? topWords.values
                                  .reduce((a, b) => a > b ? a : b)
                                  .toDouble() +
                              2
                          : 10,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.transparent,
                          tooltipPadding: EdgeInsets.zero,
                          tooltipMargin: 0,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${groupIndex + 1}', // tampilkan angka mulai dari 1
                              TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles:
                                false, // hilangkan angka di atas batang (top)
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 42,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= topWords.length)
                                return Container();
                              final key = topWords.keys.elementAt(index);
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Column(
                                  children: [
                                    Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      key,
                                      style: TextStyle(fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: topWords.entries
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final wordEntry = entry.value;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: wordEntry.value.toDouble(),
                              color: Colors.blue[900],
                              width: 18,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                          showingTooltipIndicators: [], // <--- ini penting!
                        );
                      }).toList(),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // PieChart
                Text(
                  "Top 10 Channel Billiard Berdasarkan Jumlah Video",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: PieChart(
                    PieChartData(
                      sections: generateSections(top10),
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: top10.entries.mapIndexed((index, entry) {
                    final color = colors[index % colors.length];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(backgroundColor: color, radius: 6),
                        SizedBox(width: 6),
                        Text('${entry.key} (${entry.value})',
                            style: TextStyle(fontSize: 12)),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 24),

                // Header tabel
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Row(
                    children: const [
                      Expanded(
                          flex: 3,
                          child: Text('Judul',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 2,
                          child: Text('Channel',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 4,
                          child: Text('Deskripsi',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Tabel Isi
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: limitedList.length,
                  itemBuilder: (context, index) {
                    final video = limitedList[index];
                    final isEven = index % 2 == 0;
                    return _ExpandableVideoRow(
                      video: video,
                      backgroundColor: isEven ? Colors.blue[50] : Colors.white,
                    );
                  },
                ),

                // Tombol Lihat Semua / Sembunyikan
                Center(
                  child: TextButton(
                    onPressed: () {
                      showAll.value = !showAll.value;
                    },
                    child: Text(showAll.value ? 'Sembunyikan' : 'Lihat Semua'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ExpandableVideoRow extends StatefulWidget {
  final Map<String, dynamic> video;
  final Color? backgroundColor;

  const _ExpandableVideoRow({
    Key? key,
    required this.video,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<_ExpandableVideoRow> createState() => _ExpandableVideoRowState();
}

class _ExpandableVideoRowState extends State<_ExpandableVideoRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final video = widget.video;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris utama dengan judul, channel, deskripsi dan tombol
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        right:
                            BorderSide(color: Colors.grey.shade400, width: 1),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        final url = video['link']; // langsung dari link
                        _launchURL(url);
                      },
                      child: Text(
                        video['title'] ?? '-',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: _expanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        maxLines: _expanded ? null : 1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        right:
                            BorderSide(color: Colors.grey.shade400, width: 1),
                      ),
                    ),
                    child: Text(
                      video['channel'] ?? '-',
                      overflow: _expanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      maxLines: _expanded ? null : 1,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      video['description'] ?? 'Tidak ada deskripsi',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: IconButton(
                    icon: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Detail yang muncul secara vertikal saat expand
          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                      color: Colors.grey.shade400,
                      height: 20), // Divider di atas judul

                  Text(
                    'Judul:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(video['title'] ?? '-'),
                  Divider(color: Colors.grey.shade400, height: 20),

                  Text(
                    'Channel:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(video['channel'] ?? '-'),
                  Divider(color: Colors.grey.shade400, height: 20),

                  Text(
                    'Deskripsi:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(video['description'] ?? 'Tidak ada deskripsi'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
