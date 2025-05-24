import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profil_controller.dart';

class EditProfilView extends GetView<EditProfilController> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = controller.username.value;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Profil')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nama Baru"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.updateUsername(nameController.text),
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
