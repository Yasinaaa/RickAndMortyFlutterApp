import '../../domain/entities/character.dart';

class CharacterModel extends Character {
  CharacterModel({
    required int id,
    required String name,
    required String status,
    required String species,
    required String image,
    required String location,
  }) : super(
    id: id,
    name: name,
    status: status,
    species: species,
    image: image,
    location: location,
  );

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      image: json['image'],
      location: json['location']['name'],
    );
  }
}