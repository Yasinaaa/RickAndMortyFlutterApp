import 'package:flutter/material.dart';
import 'characters_page.dart';
import 'favorites_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const CharactersPage(),
      const FavoritesPage(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
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