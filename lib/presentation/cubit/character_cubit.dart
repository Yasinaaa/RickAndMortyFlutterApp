import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/character.dart';
import '../../domain/usecases/get_characters.dart';

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

class CharacterCubit extends Cubit<CharacterState> {
  final GetCharacters getCharacters;

  CharacterCubit(this.getCharacters)
      : super(CharacterState(
    characters: [],
    favorites: <int>{},
    isLoading: false,
    page: 1,
    hasMore: true,
  ));

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true));
    try {
      final newCharacters = await getCharacters(state.page);
      emit(state.copyWith(
        characters: [...state.characters, ...newCharacters],
        page: state.page + 1,
        isLoading: false,
        hasMore: newCharacters.isNotEmpty,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void toggleFavorite(int id) {
    final updatedFavorites = Set<int>.from(state.favorites);
    if (updatedFavorites.contains(id)) {
      updatedFavorites.remove(id);
    } else {
      updatedFavorites.add(id);
    }
    emit(state.copyWith(favorites: updatedFavorites));
  }
}