import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';

class ApiService {
  final String baseUrl = "https://rickandmortyapi.com/api/character";

  Future<List<Character>> fetchCharacters() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data["results"];
      return results.map((e) => Character.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load characters");
    }
  }
}
