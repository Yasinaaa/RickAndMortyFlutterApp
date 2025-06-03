import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/character_cubit.dart';
import '../widgets/character_card.dart';
import '../../l10n/app_localizations.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<CharacterCubit>().loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCubit, CharacterState>(
      builder: (context, state) {
        if (state is CharacterLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CharacterLoaded) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.characters.length,
            itemBuilder: (context, index) {
              final character = state.characters[index];
              final isFavorite = state.favorites.contains(character.id);
              return CharacterCard(
                character: character,
                isFavorite: isFavorite,
                onFavoriteToggle: () {
                  context.read<CharacterCubit>().toggleFavorite(character);
                },
              );
            },
          );
        } else {
          return Center(child: Text(AppLocalizations.of(context)!.loadingError));
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}