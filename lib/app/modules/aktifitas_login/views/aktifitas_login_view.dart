import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/aktifitas_login/controllers/aktifitas_login_controller.dart';

class LoginActivityView extends StatelessWidget {
  final controller = Get.put(LoginActivityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktivitas Login'),
        actions: [
          // Menu untuk opsi delete all
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'refresh':
                  controller.refreshData();
                  break;
                case 'delete_all':
                  if (controller.activityLogs.isNotEmpty) {
                    controller.showDeleteAllConfirmation();
                  } else {
                    Get.snackbar(
                      'Info',
                      'Tidak ada data untuk dihapus',
                      snackPosition: SnackPosition.TOP,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 8),
                    Text('Refresh'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Hapus Semua', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memuat data aktivitas...'),
              ],
            ),
          );
        }

        if (controller.activityLogs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Belum ada aktivitas login.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshData(),
                  child: Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async => controller.refreshData(),
              child: ListView.builder(
                itemCount: controller.activityLogs.length,
                itemBuilder: (context, index) {
                  final log = controller.activityLogs[index];

                  String formattedTime = 'Waktu tidak tersedia';
                  if (log['last_activity'] != null) {
                    try {
                      final dateTime = DateTime.parse(log['last_activity']);
                      formattedTime =
                          DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
                    } catch (e) {
                      print('Error parsing date: $e');
                    }
                  }

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.login),
                        backgroundColor: Colors.blue.shade100,
                      ),
                      title: Text(
                        log['platform'] ?? 'Platform tidak diketahui',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formattedTime),
                          if (log['ip_address'] != null &&
                              log['ip_address'] != 'Unknown')
                            Text('IP: ${log['ip_address']}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                      // Tambahkan debug di bagian trailing untuk melihat data
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Debug print
                          Builder(
                            builder: (context) {
                              print('=== DEBUG LOG ${index} ===');
                              print('Platform: ${log['platform']}');
                              print('Status: ${log['status']}');
                              print('Logout time: ${log['logout_time']}');
                              print(
                                  'Logout time type: ${log['logout_time'].runtimeType}');
                              print(
                                  'Is logout_time null: ${log['logout_time'] == null}');
                              print('========================');

                              return Container(); // Empty widget untuk Builder
                            },
                          ),

                          // Status icon dengan debug
                          log['logout_time'] != null
                              ? Icon(Icons.logout, color: Colors.red.shade300)
                              : Icon(Icons.circle,
                                  color: Colors.green.shade300, size: 12),

                          SizedBox(width: 8),

                          // Status text untuk memastikan
                          Text(
                            log['logout_time'] != null ? 'OUT' : 'IN',
                            style: TextStyle(
                              fontSize: 10,
                              color: log['logout_time'] != null
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(width: 8),

                          // Delete button
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.red.shade400, size: 20),
                            onPressed: () {
                              final logId = log['id'];
                              if (logId != null &&
                                  logId.toString().isNotEmpty) {
                                controller.showDeleteConfirmation(
                                    logId.toString(),
                                    index,
                                    log['platform'] ??
                                        'Platform tidak diketahui');
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'ID log tidak ditemukan',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            tooltip: 'Hapus log ini',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Loading overlay saat delete
            if (controller.isDeleting.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Menghapus data...'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
