import 'dart:convert';
import 'package:encrypt_shared_preferences/provider.dart';
import '../models/character_model.dart';

class StorageService {
  static const String _usersKey = "encrypted_users";
  static const String _currentUserKey = "current_user";

  Future<void> saveUser(Character user) async {
    final prefs = await EncryptedSharedPreferences.getInstance();
    final usersJson = await prefs.getString(_usersKey) ?? '[]';
    final List<dynamic> usersList = json.decode(usersJson);

    if (!usersList.any((u) => u["name"] == user.name)) {
      usersList.add(user.toJson());
      await prefs.setString(_usersKey, json.encode(usersList));
    }

    await prefs.setString(_currentUserKey, json.encode(user.toJson()));
  }

  Future<Character?> getCurrentUser() async {
    final prefs = await EncryptedSharedPreferences.getInstance();
    final userJson = await prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    return Character.fromJson(json.decode(userJson));
  }

  Future<List<Character>> getSavedUsers() async {
    final prefs = await EncryptedSharedPreferences.getInstance();
    final usersJson = await prefs.getString(_usersKey) ?? '[]';
    final List<dynamic> usersList = json.decode(usersJson);
    return usersList.map((e) => Character.fromJson(e)).toList();
  }

  Future<void> logout() async {
    final prefs = await EncryptedSharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}
