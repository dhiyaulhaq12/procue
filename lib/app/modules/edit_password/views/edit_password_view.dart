import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_password_controller.dart';

class EditPasswordView extends GetView<EditPasswordController> {
  final currentController = TextEditingController();
  final newController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Password')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: currentController,
              decoration: InputDecoration(labelText: "Password Lama"),
              obscureText: true,
            ),
            TextField(
              controller: newController,
              decoration: InputDecoration(labelText: "Password Baru"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.updatePassword(
                currentController.text,
                newController.text,
              ),
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
