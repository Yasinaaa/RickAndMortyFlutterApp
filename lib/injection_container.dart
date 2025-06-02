import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'core/utils/network_info.dart';
import 'data/character_remote_datasource.dart';
import 'data/character_repository_impl.dart';
import 'domain/character_repository.dart';
import 'domain/get_characters.dart';
import 'presentation/cubit/character_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => Connectivity());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
          () => NetworkInfoImpl(sl<Connectivity>()));

  // Data sources
  sl.registerLazySingleton(() => CharacterRemoteDataSource());

  // Repository
  sl.registerLazySingleton<CharacterRepository>(() => CharacterRepositoryImpl(
    remoteDataSource: sl(),
    networkInfo: sl(),
  ));

  // UseCase
  sl.registerLazySingleton(() => GetCharacters(sl()));

  // Cubit
  sl.registerFactory(() => CharacterCubit(sl()));
}