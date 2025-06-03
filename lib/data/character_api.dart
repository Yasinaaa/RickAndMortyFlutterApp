import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'character_response.dart';

part 'character_api.g.dart';

@RestApi(baseUrl: "https://rickandmortyapi.com/api")
abstract class CharacterApi {
  factory CharacterApi(Dio dio, {String baseUrl}) = _CharacterApi;

  @GET("/character")
  Future<CharacterResponse> getCharacters(@Query("page") int page);
}