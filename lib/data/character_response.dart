import 'package:json_annotation/json_annotation.dart';
import 'character_model.dart';

part 'character_response.g.dart';

@JsonSerializable()
class CharacterResponse {
  final Info info;
  final List<CharacterModel> results;

  CharacterResponse({
    required this.info,
    required this.results
  });

  factory CharacterResponse.fromJson(Map<String, dynamic> json) =>
      _$CharacterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterResponseToJson(this);
}

@JsonSerializable()
class Info {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  Info({
    required this.count,
    required this.pages,
    this.next,
    this.prev
  });

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfoToJson(this);
}