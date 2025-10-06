import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class LoginController extends GetxController {
  final nameController = TextEditingController();
  final statusController = TextEditingController();
  final RxList<Character> users = <Character>[].obs;
  final RxList<Character> savedUsers = <Character>[].obs;
  final RxBool isLoading = false.obs;

  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    loadSavedUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final fetched = await _apiService.fetchCharacters();
      users.assignAll(fetched);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSavedUsers() async {
    final list = await _storage.getAllUsers();
    savedUsers.assignAll(list);
  }

  void login() async {
    final name = nameController.text.trim();
    final status = statusController.text.trim();

    final user = users.firstWhereOrNull(
          (u) =>
      u.name.toLowerCase() == name.toLowerCase() &&
          u.status.toLowerCase() == status.toLowerCase(),
    );

    if (user != null) {
      await _storage.saveUser(user);
      Get.snackbar("Welcome", user.name);
      Get.offAllNamed('/users');
    } else {
      Get.snackbar("Login Failed", "Invalid name or status");
    }
  }

  void fillLogin(Character user) {
    nameController.text = user.name;
    statusController.text = user.status;
  }
}
