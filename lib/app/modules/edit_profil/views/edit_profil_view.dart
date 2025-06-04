import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/edit_profil_controller.dart';

class EditProfilView extends GetView<EditProfilController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Kontainer Putih
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: controller.usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (GetStorage().read('authType') != 'google') ...[
                        TextField(
                          controller: controller.oldPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password Lama',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controller.newPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password Baru',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controller.confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Konfirmasi Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                      ElevatedButton(
                        onPressed: () {
                          controller.updateProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 150, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          // Foto Profil Bundar
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Obx(() {
                    final image = controller.selectedImagePath.value.isNotEmpty
                        ? FileImage(File(controller.selectedImagePath.value))
                        : AssetImage('assets/images/banner.jpg') as ImageProvider;

                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: image,
                      ),
                    );
                  }),
                  Positioned(
                    bottom: -5,
                    right: -5,
                    child: GestureDetector(
                      onTap: () => controller.pickImage(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
