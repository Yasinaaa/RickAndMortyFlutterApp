import '../domain/character_model_mapper.dart';
import '../core/utils/network_info.dart';
import '../domain/character.dart';
import '../domain/character_repository.dart';
import 'character_model.dart';
import 'character_remote_datasource.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Character>> getCharacters(int page) async {
    if (await networkInfo.isConnected) {
      final List<CharacterModel> models =
      await remoteDataSource.fetchCharacters(page);
      return models.map((model) => model.toEntity()).toList();
    } else {
      throw Exception('Нет подключения к интернету');
    }
  }
}