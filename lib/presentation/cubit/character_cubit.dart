import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/get_characters.dart';
import 'character_state.dart';

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