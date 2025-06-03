import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'data/character_api.dart';
import 'data/character_model.dart';
import 'data/character_repository_impl.dart';
import 'data/dio_client.dart';
import 'domain/character_repository.dart';
import 'domain/get_characters.dart';
import 'presentation/cubit/character_cubit.dart';
import 'core/utils/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final dio = createDioClient();
  sl.registerLazySingleton(() => dio);

  sl.registerLazySingleton(() => Connectivity());

  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CharacterModelAdapter());
  final characterBox = await Hive.openBox<CharacterModel>('characters');
  sl.registerLazySingleton(() => characterBox);

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl<Connectivity>()));

  // API
  sl.registerLazySingleton<CharacterApi>(() => CharacterApi(sl<Dio>()));

  // Repository
  sl.registerLazySingleton<CharacterRepository>(() => CharacterRepositoryImpl(
    api: sl<CharacterApi>(),
    cacheBox: sl<Box<CharacterModel>>(),
    networkInfo: sl<NetworkInfo>(),
  ));

  // Use Case
  sl.registerLazySingleton(() => GetCharacters(sl<CharacterRepository>()));

  // Cubit
  sl.registerFactory(() => CharacterCubit(sl<GetCharacters>()));
}