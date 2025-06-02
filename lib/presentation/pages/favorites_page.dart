import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/character_cubit.dart';
import '../widgets/character_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body: BlocBuilder<CharacterCubit, CharacterState>(
        builder: (context, state) {
          final favorites = state.characters
              .where((char) => state.favorites.contains(char.id))
              .toList();

          if (favorites.isEmpty) {
            return const Center(child: Text('Нет избранных персонажей'));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final char = favorites[index];
              return CharacterCard(
                character: char,
                isFavorite: true,
                onFavoriteToggle: () => context
                    .read<CharacterCubit>()
                    .toggleFavorite(char.id),
              );
            },
          );
        },
      ),
    );
  }
}