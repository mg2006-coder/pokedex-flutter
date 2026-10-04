import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;

    if (favorites.isEmpty) {
      return const SafeArea(
        child: Center(child: Text('No favorites yet. Tap a heart to add one.')),
      );
    }

    return SafeArea(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final pokemon = favorites[index];
          return PokemonCard(
            pokemon: pokemon,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PokemonDetailScreen(pokemonId: pokemon.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
