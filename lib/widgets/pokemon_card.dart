import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pokemon_summary.dart';
import '../providers/favorites_provider.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({super.key, required this.pokemon, required this.onTap});

  final PokemonSummary pokemon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<FavoritesProvider, bool>(
      (p) => p.isFavorite(pokemon.id),
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () =>
                      context.read<FavoritesProvider>().toggle(pokemon),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Image.network(
                  pokemon.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.catching_pokemon, size: 48),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                pokemon.formattedId,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                capitalize(pokemon.name),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
