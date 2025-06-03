import 'package:hive/hive.dart';

import '../domain/character_model_mapper.dart';
import '../core/utils/network_info.dart';
import '../domain/character.dart';
import '../domain/character_repository.dart';
import 'character_api.dart';
import 'character_model.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterApi api;
  final Box<CharacterModel> cacheBox;
  final NetworkInfo networkInfo;

  CharacterRepositoryImpl({
    required this.api,
    required this.cacheBox,
    required this.networkInfo,
  });

  @override
  Future<List<Character>> getCharacters(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await api.getCharacters(page);
        final models = response.results;

        for (var model in models) {
          cacheBox.put(model.id, model);
        }

        return models.map((m) => m.toEntity()).toList();
      } catch (e) {
        return _getFromCache();
      }
    } else {
      return _getFromCache();
    }
  }

  List<Character> _getFromCache() {
    return cacheBox.values.toList().map((c) => c.toEntity()).toList();
  }
}