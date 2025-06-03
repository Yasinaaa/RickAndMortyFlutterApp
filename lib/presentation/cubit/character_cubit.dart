import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/character.dart';
import '../../../domain/get_characters.dart';

part 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  final GetCharacters getCharacters;

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  final List<Character> _characters = [];
  final Set<int> _favoriteIds = {};

  CharacterCubit(this.getCharacters) : super(CharacterInitial());

  Future<void> loadInitial() async {
    emit(CharacterLoading());
    _currentPage = 1;
    _hasMore = true;
    _characters.clear();

    try {
      final result = await getCharacters(_currentPage);
      _characters.addAll(result);
      emit(CharacterLoaded(List.of(_characters), Set.of(_favoriteIds)));
    } catch (e) {
      emit(CharacterError('Failed to load characters'));
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    _currentPage++;

    try {
      final result = await getCharacters(_currentPage);
      if (result.isEmpty) {
        _hasMore = false;
      } else {
        _characters.addAll(result);
        emit(CharacterLoaded(List.of(_characters), Set.of(_favoriteIds)));
      }
    } catch (_) {
      _hasMore = false;
    }

    _isLoadingMore = false;
  }

  void toggleFavorite(Character character) {
    if (_favoriteIds.contains(character.id)) {
      _favoriteIds.remove(character.id);
    } else {
      _favoriteIds.add(character.id);
    }

    emit(CharacterLoaded(List.of(_characters), Set.of(_favoriteIds)));
  }

  List<Character> get favorites => _characters
      .where((c) => _favoriteIds.contains(c.id))
      .toList();

  bool isFavorite(Character character) =>
      _favoriteIds.contains(character.id);
}