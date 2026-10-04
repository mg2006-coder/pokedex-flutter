import 'package:flutter/material.dart';

import 'favorites_screen.dart';
import 'pokemon_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [PokemonListScreen(), FavoritesScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Pokedex'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }
}
