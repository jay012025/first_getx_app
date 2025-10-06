import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/users_controller.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usersController = Get.put(UsersController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: usersController.logout,
          ),
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
            _buildFilterRow(usersController),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, i) {
                  final user = users[i];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(user.image)),
                      title: Text(user.name),
                      subtitle: Text("${user.status} | ${user.species} | ${user.gender}"),
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

  Widget _buildFilterRow(UsersController c) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _filterGroup("Status", c.getStatusList(), c.selectedStatus),
          const SizedBox(width: 8),
          _filterGroup("Species", c.getSpeciesList(), c.selectedSpecies),
          const SizedBox(width: 8),
          _filterGroup("Gender", c.getGenderList(), c.selectedGender),
        ],
      ),
    );
  }

  Widget _filterGroup(String title, List<String> options, RxString selected) {
    return Row(
      children: [
        Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        ...options.map((e) {
          final isSelected = selected.value == e;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(e),
              selected: isSelected,
              onSelected: (_) => selected.value = isSelected ? "" : e,
            ),
          );
        }),
      ],
    );
  }
}
