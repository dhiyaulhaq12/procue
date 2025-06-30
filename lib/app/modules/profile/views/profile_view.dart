import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Get.offAllNamed('/dashboard'), // ⬅️ langsung ke dashboard
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 4), // sedikit kiri agar sejajar
          child: Text(
            'Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Hilangkan bagian Positioned untuk judul yang lama,
          // karena sudah pakai AppBar

          Positioned(
            top: 100, // geser ke atas karena appBar sudah ada
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => Text(
                        controller.username.value.isEmpty
                            ? 'Loading...'
                            : controller.username.value,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 12),
                  Obx(() {
                    final isGoogle = controller.authType.value == 'google';

                    if (isGoogle)
                      return SizedBox
                          .shrink(); // Jangan tampilkan tombol sama sekali

                    return ElevatedButton.icon(
                      onPressed: () async {
                        await Get.toNamed('/edit-profile');
                        controller.fetchUserData();
                        controller.loadSavedProfilePicture();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black,
                        elevation: 1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text("Edit Profil"),
                    );
                  }),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed('/aktifitas-login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.black,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(Icons.history, size: 18),
                    label: const Text("Aktivitas Login"),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Obx(() => _infoTile(
                              icon: Icons.email,
                              value: controller.email.value.isEmpty
                                  ? 'Loading...'
                                  : controller.email.value,
                            )),
                        const SizedBox(height: 12),
                        _infoTile(icon: Icons.lock, value: '••••••••'),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Get.defaultDialog(
                              title: "Keluar",
                              middleText: "Apakah kamu yakin ingin keluar?",
                              textCancel: "Batal",
                              textConfirm: "Keluar",
                              confirmTextColor: Colors.white,
                              onConfirm: () {
                                Get.back();
                                controller.logout();
                              },
                            );
                          },
                          child:
                              _infoTile(icon: Icons.logout, value: 'Log Out'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 20, // posisinya sedikit lebih atas karena appBar ada
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Obx(() {
                  ImageProvider image;
                  if (controller.profilePictureUrl.value.isNotEmpty) {
                    if (controller.profilePictureUrl.value.startsWith('http')) {
                      image = NetworkImage(controller.profilePictureUrl.value);
                    } else {
                      image =
                          FileImage(File(controller.profilePictureUrl.value));
                    }
                  } else {
                    image = AssetImage('assets/images/profile.png');
                  }
                  return CircleAvatar(
                    radius: 60,
                    backgroundImage: image,
                    backgroundColor: Colors.grey[300],
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading profile image: $exception');
                    },
                    child: controller.profilePictureUrl.value.isEmpty
                        ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                        : null,
                  );
                }),
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
                height: 50,
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

  Widget _infoTile({required IconData icon, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
