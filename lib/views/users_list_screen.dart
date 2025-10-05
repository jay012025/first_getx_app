import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/users_controller.dart';
import '../models/character_model.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize UsersController if not already
    final usersController = Get.put(UsersController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => usersController.logout(),
          )
        ],
      ),
      body: Obx(() {
        if (usersController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = usersController.filteredUsers;

        if (users.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        return Column(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterGroup("Status", usersController.getStatusList(), usersController.selectedStatus),
                  const SizedBox(width: 8),
                  _buildFilterGroup("Species", usersController.getSpeciesList(), usersController.selectedSpecies),
                  const SizedBox(width: 8),
                  _buildFilterGroup("Gender", usersController.getGenderList(), usersController.selectedGender),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.image),
                        radius: 30,
                      ),
                      title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Status: ${user.status}"),
                          Text("Species: ${user.species}"),
                          Text("Gender: ${user.gender}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterGroup(String title, List<String> options, RxString selectedFilter) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...options.map((e) {
          final isSelected = e == selectedFilter.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(e),
              selected: isSelected,
              selectedColor: Colors.teal,
              onSelected: (_) {
                selectedFilter.value = isSelected ? "" : e;
              },
            ),
          );
        }).toList(),
      ],
    );
  }
}
