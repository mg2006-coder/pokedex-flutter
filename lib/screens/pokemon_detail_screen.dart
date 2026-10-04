import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pokemon_detail.dart';
import '../models/pokemon_summary.dart';
import '../providers/favorites_provider.dart';
import '../services/pokemon_api_service.dart';
import '../widgets/pokemon_card.dart' show capitalize;

const _typeColors = <String, Color>{
  'fire': Color(0xFFFB6C6C),
  'water': Color(0xFF76BDFE),
  'grass': Color(0xFF48D0B0),
  'electric': Color(0xFFFFD86F),
  'poison': Color(0xFFA974D4),
  'bug': Color(0xFFA8B820),
  'normal': Color(0xFFA8A878),
  'flying': Color(0xFF9DB7F5),
  'ground': Color(0xFFE0C068),
  'fairy': Color(0xFFF4B6D6),
  'fighting': Color(0xFFC03028),
  'psychic': Color(0xFFF85888),
  'rock': Color(0xFFB8A038),
  'ghost': Color(0xFF705898),
  'ice': Color(0xFF98D8D8),
  'dragon': Color(0xFF7038F8),
  'dark': Color(0xFF705848),
  'steel': Color(0xFFB8B8D0),
};

Color typeColor(String type) => _typeColors[type] ?? Colors.grey;

class PokemonDetailScreen extends StatefulWidget {
  const PokemonDetailScreen({super.key, required this.pokemonId});

  final int pokemonId;

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late Future<PokemonDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  Future<PokemonDetail> _fetch() =>
      context.read<PokemonApiService>().fetchDetail(widget.pokemonId);

  void _retry() => setState(() => _future = _fetch());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PokemonDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(snapshot.error.toString()),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _retry,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return _DetailBody(detail: snapshot.data!);
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.detail});

  final PokemonDetail detail;

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<FavoritesProvider, bool>(
      (p) => p.isFavorite(detail.id),
    );
    final mainColor = typeColor(detail.types.first);

    return Container(
      color: mainColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () => context.read<FavoritesProvider>().toggle(
                      PokemonSummary(id: detail.id, name: detail.name),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    capitalize(detail.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    detail.formattedId,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  children: [
                    for (final t in detail.types)
                      Chip(
                        label: Text(
                          capitalize(t),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.white24,
                        side: BorderSide.none,
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: Image.network(detail.imageUrl, fit: BoxFit.contain),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _InfoTile(
                          label: 'Height',
                          value: '${detail.heightInMetres} m',
                        ),
                        _InfoTile(
                          label: 'Weight',
                          value: '${detail.weightInKg} kg',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Abilities',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final a in detail.abilities)
                          Chip(label: Text(capitalize(a))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Base Stats',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final s in detail.stats)
                      _StatRow(stat: s, color: mainColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.stat, required this.color});

  final PokemonStat stat;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(capitalize(stat.name.replaceAll('-', ' '))),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '${stat.value}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (stat.value / 255).clamp(0.0, 1.0),
                minHeight: 8,
                color: color,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
