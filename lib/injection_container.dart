import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'data/datasources/character_remote_datasource.dart';
import 'data/repositories/character_repository_impl.dart';
import 'domain/repositories/character_repository.dart';
import 'domain/usecases/get_characters.dart';
import 'presentation/cubit/character_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Presentation
  sl.registerFactory(() => CharacterCubit(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetCharacters(sl()));

  // Repository
  sl.registerLazySingleton<CharacterRepository>(
          () => CharacterRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton(() => CharacterRemoteDataSource());

  // External
  sl.registerLazySingleton(() => http.Client());
}