import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(const RickAndMortyApp());

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<int> _favorites = [];
  List _allCharacters = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('favorites') ?? [];
    setState(() {
      _favorites.addAll(stored.map(int.parse));
    });
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favorites.map((e) => e.toString()).toList());
  }

  void toggleFavorite(int id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
      saveFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      CharacterListScreen(
        favorites: _favorites,
        onToggleFavorite: toggleFavorite,
      ),
      FavoriteScreen(
        characters: _allCharacters
            .where((char) => _favorites.contains(char['id']))
            .toList(),
        onRemoveFavorite: toggleFavorite,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Персонажи'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), label: 'Избранное'),
        ],
      ),
    );
  }
}

class CharacterListScreen extends StatefulWidget {
  final List<int> favorites;
  final Function(int) onToggleFavorite;

  const CharacterListScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  List characters = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    loadCachedData();
    fetchCharacters();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !isLoading &&
        hasMore) {
      fetchCharacters();
    }
  }

  Future<void> loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cachedCharacters');
    if (raw != null) {
      final List cached = json.decode(raw);
      setState(() {
        characters = cached;
      });
    }
  }

  Future<void> cacheCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cachedCharacters', json.encode(characters));
  }

  Future<void> fetchCharacters() async {
    setState(() => isLoading = true);
    final response = await http
        .get(Uri.parse('https://rickandmortyapi.com/api/character?page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newCharacters = data['results'];
      setState(() {
        page++;
        characters.addAll(newCharacters);
        hasMore = data['info']['next'] != null;
        isLoading = false;
      });
      cacheCharacters();
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Characters'),
        backgroundColor: Colors.green[700],
      ),
      body: characters.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        itemCount: characters.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= characters.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final character = characters[index];
          final id = character['id'];
          final isFavorite = widget.favorites.contains(id);
          return CharacterCard(
            character: character,
            isFavorite: isFavorite,
            onFavoriteToggle: () => widget.onToggleFavorite(id),
          );
        },
      ),
    );
  }
}

class FavoriteScreen extends StatefulWidget {
  final List characters;
  final Function(int) onRemoveFavorite;

  const FavoriteScreen({
    super.key,
    required this.characters,
    required this.onRemoveFavorite,
  });

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String sortBy = 'name';

  @override
  Widget build(BuildContext context) {
    List sorted = [...widget.characters];
    sorted.sort((a, b) => a[sortBy].compareTo(b[sortBy]));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        backgroundColor: Colors.amber[700],
        actions: [
          DropdownButton<String>(
            value: sortBy,
            dropdownColor: Colors.white,
            onChanged: (value) => setState(() => sortBy = value!),
            items: const [
              DropdownMenuItem(value: 'name', child: Text('Имя')),
              DropdownMenuItem(value: 'status', child: Text('Статус')),
              DropdownMenuItem(value: 'species', child: Text('Вид')),
            ],
          )
        ],
      ),
      body: sorted.isEmpty
          ? const Center(child: Text('Нет избранных персонажей'))
          : ListView.builder(
        itemCount: sorted.length,
        itemBuilder: (context, index) {
          final character = sorted[index];
          return CharacterCard(
            character: character,
            isFavorite: true,
            onFavoriteToggle: () => widget.onRemoveFavorite(character['id']),
          );
        },
      ),
    );
  }
}

class CharacterCard extends StatelessWidget {
  final Map character;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CharacterCard({
    super.key,
    required this.character,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(character['image']),
        title: Text(character['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${character['status']}'),
            Text('Species: ${character['species']}'),
            Text('Location: ${character['location']['name']}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.amber : null,
          ),
          onPressed: onFavoriteToggle,
        ),
        isThreeLine: true,
      ),
    );
  }
}