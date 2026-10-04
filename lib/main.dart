import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'screens/home_screen.dart';
import 'services/pokemon_api_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => PokemonApiService()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()..load()),
      ],
      child: const PokedexApp(),
    ),
  );
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        scaffoldBackgroundColor: const Color(0xFFF6F6F8),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
