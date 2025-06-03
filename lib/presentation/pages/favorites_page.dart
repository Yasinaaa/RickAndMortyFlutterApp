import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/character_cubit.dart';
import '../widgets/character_card.dart';
import '../../l10n/app_localizations.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String _sortBy = 'name';

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CharacterCubit>();
    var favorites = cubit.favorites;

    if (_sortBy == 'name') {
      favorites.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortBy == 'status') {
      favorites.sort((a, b) => a.status.compareTo(b.status));
    }

    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Text(
                localizations.sortBy,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _sortBy,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: [
                          DropdownMenuItem(
                            value: 'name',
                            child: Text(localizations.byName),
                          ),
                          DropdownMenuItem(
                            value: 'status',
                            child: Text(localizations.byStatus),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _sortBy = val);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final character = favorites[index];
              return CharacterCard(
                character: character,
                isFavorite: true,
                onFavoriteToggle: () {
                  context.read<CharacterCubit>().toggleFavorite(character);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}