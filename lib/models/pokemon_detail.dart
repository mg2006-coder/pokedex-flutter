class PokemonStat {
  const PokemonStat({required this.name, required this.value});

  final String name;
  final int value;
}

class PokemonDetail {
  const PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.stats,
  });

  final int id;
  final String name;
  final int height; // decimetres
  final int weight; // hectograms
  final List<String> types;
  final List<String> abilities;
  final List<PokemonStat> stats;

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      types: (json['types'] as List)
          .map((t) => (t['type'] as Map<String, dynamic>)['name'] as String)
          .toList(),
      abilities: (json['abilities'] as List)
          .map((a) => (a['ability'] as Map<String, dynamic>)['name'] as String)
          .toList(),
      stats: (json['stats'] as List)
          .map(
            (s) => PokemonStat(
              name: (s['stat'] as Map<String, dynamic>)['name'] as String,
              value: s['base_stat'] as int,
            ),
          )
          .toList(),
    );
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  String get formattedId => '#${id.toString().padLeft(3, '0')}';

  double get heightInMetres => height / 10;
  double get weightInKg => weight / 10;
}
