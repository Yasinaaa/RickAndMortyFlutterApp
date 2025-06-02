import '../data/character_model.dart';
import 'character.dart';

extension CharacterModelMapper on CharacterModel {
  Character toEntity() {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      image: image,
      location: location,
    );
  }
}