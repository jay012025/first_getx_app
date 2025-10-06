import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';

class ApiService {
  Future<List<Character>> fetchCharacters() async {
    const url = 'https://rickandmortyapi.com/api/character';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((e) => Character.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
