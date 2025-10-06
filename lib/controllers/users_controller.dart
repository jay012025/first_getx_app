import 'package:get/get.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class UsersController extends GetxController {
  final RxList<Character> characters = <Character>[].obs;
  final RxList<Character> filteredUsers = <Character>[].obs;
  final Rx<Character?> currentUser = Rx<Character?>(null);
  final RxBool isLoading = false.obs;

  final RxString selectedStatus = "".obs;
  final RxString selectedSpecies = "".obs;
  final RxString selectedGender = "".obs;

  final StorageService _storage = StorageService();
  final ApiService _api = ApiService();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await loadCurrentUser();
    await fetchCharacters();
  }

  Future<void> loadCurrentUser() async {
    currentUser.value = await _storage.getCurrentUser();
  }

  Future<void> fetchCharacters() async {
    isLoading.value = true;
    try {
      final data = await _api.fetchCharacters();
      characters.assignAll(data);
      applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    filteredUsers.value = characters.where((c) {
      if (currentUser.value != null && c.id == currentUser.value!.id) return false;
      if (selectedStatus.value.isNotEmpty && c.status != selectedStatus.value) return false;
      if (selectedSpecies.value.isNotEmpty && c.species != selectedSpecies.value) return false;
      if (selectedGender.value.isNotEmpty && c.gender != selectedGender.value) return false;
      return true;
    }).toList();
  }

  void logout() async {
    await _storage.logout();
    Get.offAllNamed('/');
  }

  List<String> getStatusList() => characters.map((c) => c.status).toSet().toList();
  List<String> getSpeciesList() => characters.map((c) => c.species).toSet().toList();
  List<String> getGenderList() => characters.map((c) => c.gender).toSet().toList();
}
