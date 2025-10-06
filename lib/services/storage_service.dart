import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/character_model.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveUser(Character user) async {
    final allUsers = await getAllUsers();
    if (allUsers.every((u) => u.id != user.id)) {
      allUsers.add(user);
    }

    await _storage.write(
      key: 'users',
      value: jsonEncode(allUsers.map((e) => e.toJson()).toList()),
    );

    await _storage.write(
      key: 'current_user',
      value: jsonEncode(user.toJson()),
    );
  }

  Future<Character?> getCurrentUser() async {
    final data = await _storage.read(key: 'current_user');
    if (data != null) {
      return Character.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<List<Character>> getAllUsers() async {
    final data = await _storage.read(key: 'users');
    if (data != null) {
      final List list = jsonDecode(data);
      return list.map((e) => Character.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> logout() async {
    await _storage.delete(key: 'current_user');
  }
}
