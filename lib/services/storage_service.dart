import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/character_model.dart';

class StorageService {
    final _storage = const FlutterSecureStorage();

    Future<void> saveUser(Character user) async {
        List<Character> allUsers = await getAllUsers();
        if (allUsers.every((u) => u.id != user.id)) {
            allUsers.add(user);
        }

        await _storage.write(
            key: 'users',
            value: jsonEncode(allUsers.map((e) => e.toJson()).toList())
        );

        await _storage.write(
            key: 'current_user',
            value: jsonEncode(user.toJson())
        );
    }

    Future<Character> getCurrentUser() async {
        String data = await _storage.read(key: 'current_user') ?? "";
        if (data.isNotEmpty) {
            return Character.fromJson(jsonDecode(data));
        }

        // ✅ Return an empty Character instead of null
        return Character(
            id: 0,
            name: '',
            status: '',
            species: '',
            gender: '',
            image: ''
        );
    }

    Future<List<Character>> getAllUsers() async {
        String data = await _storage.read(key: 'users') ?? "";
        if (data.isNotEmpty) {
            List list = jsonDecode(data);
            return list.map((e) => Character.fromJson(e)).toList();
        }
        return <Character>[];
    }

    Future<void> logout() async {
        await _storage.delete(key: 'current_user');
    }
}
