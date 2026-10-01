class PokemonSummary {
  const PokemonSummary({required this.id, required this.name});

  final int id;
  final String name;

  /// List API sirf name aur url deti hai, isliye id url se nikalte hain.
  factory PokemonSummary.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final segments = Uri.parse(url).pathSegments
        .where((s) => s.isNotEmpty)
        .toList();
    return PokemonSummary(
      id: int.parse(segments.last),
      name: json['name'] as String,
    );
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  String get formattedId => '#${id.toString().padLeft(3, '0')}';
}
