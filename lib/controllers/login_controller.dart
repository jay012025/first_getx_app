import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/character_model.dart';
import '../services/storage_service.dart';
import 'users_controller.dart';

class LoginController extends GetxController {
  final nameController = TextEditingController();
  final statusController = TextEditingController();
  final StorageService _storageService = StorageService();

  RxList<Character> savedUsers = <Character>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedUsers();
    if (!Get.isRegistered<UsersController>()) {
      Get.put(UsersController());
    }
    final usersController = Get.find<UsersController>();
    usersController.fetchCharacters();
  }

  Future<void> loadSavedUsers() async {
    final users = await _storageService.getSavedUsers();
    savedUsers.assignAll(users);
  }

  void login() async {
    final nameInput = nameController.text.trim();
    final statusInput = statusController.text.trim();

    if (nameInput.isEmpty || statusInput.isEmpty) {
      Get.snackbar("Error", "Please enter both name and status");
      return;
    }

    final usersController = Get.find<UsersController>();

    Character? found;
    try {
      found = usersController.characters.firstWhere(
            (c) =>
        c.name.toLowerCase() == nameInput.toLowerCase() &&
            c.status.toLowerCase() == statusInput.toLowerCase(),
      );
    } catch (e) {
      found = null;
    }

    if (found != null) {
      await _storageService.saveUser(found);
      await loadSavedUsers();
      Get.snackbar("Success", "Welcome ${found.name}");
      nameController.clear();
      statusController.clear();
      Get.toNamed("/users");
    } else {
      Get.snackbar("Login Failed", "Invalid name or status");
    }
  }

  void quickLogin(Character user) async {
    await _storageService.saveUser(user);
    Get.snackbar("Welcome Back", "Logged in as ${user.name}");
    Get.toNamed("/users");
  }
}
