import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔻 Custom Bottom Navigation - Disesuaikan dengan Dashboard
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(27),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Get.offAllNamed(
                    '/dashboard'); // Navigasi ke Dashboard dan hapus history
              },
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                Get.toNamed('/about'); // ⬅️ Navigasi ke halaman About
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {
                // Navigasi ke halaman Profil lewat route GetX
                Get.toNamed('/profile');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text('Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  AssetImage('assets/avatar.png'), // ganti sesuai kebutuhan
            ),
            const SizedBox(height: 12),
            const Text("Reza Rahardian",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.deepPurple),
                      title: Text("rezarahardian@gmail.com"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.deepPurple),
                      title: Text("Reza Rahardian"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.lock, color: Colors.deepPurple),
                      title: Text("********"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                    Divider(),
                    ListTile(
                      leading:
                          Icon(Icons.verified_user, color: Colors.deepPurple),
                      title: Text("Otentikasi Dua Faktor"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.deepPurple),
                      title: Text("Keluar"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Get.defaultDialog(
                          title: "Keluar",
                          middleText: "Apakah kamu yakin ingin keluar?",
                          textCancel: "Batal",
                          textConfirm: "Keluar",
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            Get.back(); // Tutup dialog
                            controller.logout();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
