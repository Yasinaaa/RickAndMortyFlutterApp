import 'character.dart';

abstract class CharacterRepository {
  Future<List<Character>> getCharacters(int page);
}