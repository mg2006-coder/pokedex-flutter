import 'pokemon_summary.dart';

class PokemonPage {
  const PokemonPage({required this.items, this.nextUrl});

  final List<PokemonSummary> items;
  final String? nextUrl;

  factory PokemonPage.fromJson(Map<String, dynamic> json) {
    return PokemonPage(
      items: (json['results'] as List)
          .map((e) => PokemonSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextUrl: json['next'] as String?,
    );
  }
}
