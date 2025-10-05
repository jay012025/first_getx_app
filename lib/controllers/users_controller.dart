import 'package:get/get.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class UsersController extends GetxController {
  final RxList<Character> characters = <Character>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<Character?> currentUser = Rx<Character?>(null);

  // Filters
  final RxString selectedStatus = "".obs;
  final RxString selectedSpecies = "".obs;
  final RxString selectedGender = "".obs;

  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    isLoading.value = true;
    try {
      final result = await _apiService.fetchCharacters();
      characters.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch characters");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCurrentUser() async {
    final user = await _storageService.getCurrentUser();
    currentUser.value = user;
  }

  Future<void> logout() async {
    await _storageService.logout();
    currentUser.value = null;
    Get.offAllNamed('/');
  }

  // Filtered users excluding current user
  RxList<Character> get filteredUsers => characters
      .where((c) => c.id != currentUser.value?.id)
      .where((c) =>
  (selectedStatus.value.isEmpty || c.status == selectedStatus.value) &&
      (selectedSpecies.value.isEmpty || c.species == selectedSpecies.value) &&
      (selectedGender.value.isEmpty || c.gender == selectedGender.value))
      .toList()
      .obs;

  List<String> getStatusList() => characters.map((c) => c.status).toSet().toList();
  List<String> getSpeciesList() => characters.map((c) => c.species).toSet().toList();
  List<String> getGenderList() => characters.map((c) => c.gender).toSet().toList();
}
