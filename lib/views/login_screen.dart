import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../models/character_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.statusController,
              decoration: const InputDecoration(labelText: "Status"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.login,
              child: const Text("Login"),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Saved Profiles", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.savedUsers.isEmpty) {
                  return const Center(child: Text("No saved users yet"));
                }
                return ListView.builder(
                  itemCount: controller.savedUsers.length,
                  itemBuilder: (context, index) {
                    final user = controller.savedUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.image),
                        radius: 25,
                      ),
                      title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(user.status),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.removeProfile(user.id),
                      ),
                      onTap: () {
                        controller.nameController.text = user.name;
                        controller.statusController.text = user.status;
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
