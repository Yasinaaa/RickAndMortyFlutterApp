import 'character.dart';
import 'character_repository.dart';

class GetCharacters {
  final CharacterRepository repository;

  GetCharacters(this.repository);

  Future<List<Character>> call(int page) => repository.getCharacters(page);
}