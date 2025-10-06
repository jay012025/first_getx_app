import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'users_controller.dart';

class LoginController extends GetxController {
  final nameController = TextEditingController();
  final statusController = TextEditingController();

  final RxList<Character> apiUsers = <Character>[].obs;
  final RxList<Character> savedUsers = <Character>[].obs;
  final RxBool isLoading = false.obs;

  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchApiUsers();
    loadSavedUsers();
  }

  Future<void> fetchApiUsers() async {
    isLoading.value = true;
    try {
      final result = await _apiService.fetchCharacters();
      apiUsers.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to load users");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSavedUsers() async {
    final users = await _storageService.getAllUsers();
    savedUsers.assignAll(users);
  }

  Future<void> login() async {
    final name = nameController.text.trim();
    final status = statusController.text.trim();

    final matchedUser = apiUsers.firstWhere(
          (u) => u.name.toLowerCase() == name.toLowerCase() && u.status.toLowerCase() == status.toLowerCase(),
      orElse: () => Character(id: 0, name: '', status: '', species: '', gender: '', image: ''),
    );

    if (matchedUser.id != 0) {
      await _storageService.saveUser(matchedUser);
      await loadSavedUsers();

      if (!Get.isRegistered<UsersController>()) {
        Get.put(UsersController());
      }

      Get.toNamed('/users');
      Get.snackbar("Success", "Welcome ${matchedUser.name}");
    } else {
      Get.snackbar("Login Failed", "Invalid name or status");
    }
  }

  Future<void> removeProfile(int id) async {
    await _storageService.removeUser(id);
    await loadSavedUsers();
  }
}
