import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/character_cubit.dart';
import '../cubit/character_state.dart';
import '../widgets/character_card.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCubit, CharacterState>(
        builder: (context, state) {
          if (state.isLoading && state.characters.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200 &&
                  !state.isLoading &&
                  state.hasMore) {
                context.read<CharacterCubit>().loadMore();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: state.characters.length,
              itemBuilder: (context, index) {
                final character = state.characters[index];
                final isFavorite =
                state.favorites.contains(character.id);

                return CharacterCard(
                  character: character,
                  isFavorite: isFavorite,
                  onFavoriteToggle: () => context
                      .read<CharacterCubit>()
                      .toggleFavorite(character.id),
                );
              },
            ),
          );
        },
    );
  }
}