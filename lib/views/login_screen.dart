import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../controllers/users_controller.dart';
import '../models/character_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(title: const Text("Rick & Morty Login")),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: "Character Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.statusController,
                decoration: const InputDecoration(
                  labelText: "Character Status (Alive / Dead / unknown)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.login();
                  // Ensure UsersController is initialized before navigating
                  if (!Get.isRegistered<UsersController>()) {
                    Get.put(UsersController());
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text("Login"),
              ),
              const SizedBox(height: 20),
              if (controller.savedUsers.isNotEmpty) ...[
                const Text("Saved Profiles",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.savedUsers.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final user = controller.savedUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.image),
                        radius: 25,
                      ),
                      title: Text(user.name),
                      subtitle: Text(user.status),
                      onTap: () {
                        controller.quickLogin(user);
                        if (!Get.isRegistered<UsersController>()) {
                          Get.put(UsersController());
                        }
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
