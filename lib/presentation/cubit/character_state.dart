import '../../domain/character.dart';

class CharacterState {
  final List<Character> characters;
  final Set<int> favorites;
  final bool isLoading;
  final int page;
  final bool hasMore;

  CharacterState({
    required this.characters,
    required this.favorites,
    required this.isLoading,
    required this.page,
    required this.hasMore,
  });

  CharacterState copyWith({
    List<Character>? characters,
    Set<int>? favorites,
    bool? isLoading,
    int? page,
    bool? hasMore,
  }) {
    return CharacterState(
      characters: characters ?? this.characters,
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}