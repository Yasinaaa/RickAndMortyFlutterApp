import 'dart:convert';
import 'package:http/http.dart' as http;
import 'character_model.dart';

class CharacterRemoteDataSource {
  Future<List<CharacterModel>> fetchCharacters(int page) async {
    final response = await http.get(
        Uri.parse('https://rickandmortyapi.com/api/character?page=$page')
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((item) => CharacterModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }
}