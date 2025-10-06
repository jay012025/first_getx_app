import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
    const LoginScreen({super.key});

    @override
    Widget build(BuildContext context) {
        final controller = Get.put(LoginController());

        return Scaffold(
            appBar: AppBar(title: const Text("Login")),
            body: Obx(() {
                    if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                    }

                    return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                TextField(
                                    controller: controller.nameController,
                                    decoration: const InputDecoration(labelText: "Name")
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                    controller: controller.statusController,
                                    decoration: const InputDecoration(labelText: "Status")
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                    onPressed: controller.login,
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                                    child: const Text("Login")
                                ),
                                const SizedBox(height: 20),
                                const Divider(),
                                const Text(
                                    "Saved Profiles",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                ),
                                const SizedBox(height: 10),
                                Obx(() {
                                        final users = controller.savedUsers;
                                        if (users.isEmpty) {
                                            return const Text("No saved users yet");
                                        }
                                        return Wrap(
                                            spacing: 12,
                                            children: users.map((user) {
                                                    return GestureDetector(
                                                        onTap: () => controller.fillLogin(user),
                                                        child: Column(
                                                            children: [
                                                                CircleAvatar(
                                                                    radius: 30,
                                                                    backgroundImage: NetworkImage(user.image)
                                                                ),
                                                                const SizedBox(height: 4),
                                                                Text(
                                                                    user.name,
                                                                    style: const TextStyle(fontSize: 12),
                                                                    overflow: TextOverflow.ellipsis
                                                                )
                                                            ]
                                                        )
                                                    );
                                                }).toList()
                                        );
                                    })
                            ]
                        )
                    );
                })
        );
    }
}
