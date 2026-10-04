import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pokemon_summary.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _storageKey = 'favorite_pokemon';

  final Map<int, PokemonSummary> _items = {};

  List<PokemonSummary> get favorites =>
      _items.values.toList()..sort((a, b) => a.id.compareTo(b.id));

  bool isFavorite(int id) => _items.containsKey(id);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_storageKey) ?? [];
    _items.clear();
    for (final raw in saved) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final p = PokemonSummary(
        id: map['id'] as int,
        name: map['name'] as String,
      );
      _items[p.id] = p;
    }
    notifyListeners();
  }

  Future<void> toggle(PokemonSummary pokemon) async {
    if (_items.containsKey(pokemon.id)) {
      _items.remove(pokemon.id);
    } else {
      _items[pokemon.id] = pokemon;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      _items.values
          .map((p) => jsonEncode({'id': p.id, 'name': p.name}))
          .toList(),
    );
  }
}
