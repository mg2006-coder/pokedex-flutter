import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pokemon_summary.dart';
import '../services/pokemon_api_service.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final _scrollController = ScrollController();
  final List<PokemonSummary> _items = [];
  String? _nextUrl;
  bool _isLoading = false;
  String? _error;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) _load();
  }

  Future<void> _load() async {
    if (_isLoading) return;
    if (_items.isNotEmpty && _nextUrl == null) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final page = await context.read<PokemonApiService>().fetchPage(
        nextUrl: _nextUrl,
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(page.items);
        _nextUrl = page.nextUrl;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items
        .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search Pokemon',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(child: _buildBody(filtered)),
        ],
      ),
    );
  }

  Widget _buildBody(List<PokemonSummary> filtered) {
    if (_items.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_items.isEmpty && _error != null) {
      return _ErrorView(message: _error!, onRetry: _load);
    }
    if (filtered.isEmpty) {
      return const Center(child: Text('No Pokemon found'));
    }
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: filtered.length + (_isLoading || _error != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= filtered.length) {
          return _error != null
              ? _ErrorView(message: _error!, onRetry: _load)
              : const Center(child: CircularProgressIndicator());
        }
        final pokemon = filtered[index];
        return PokemonCard(
          pokemon: pokemon,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PokemonDetailScreen(pokemonId: pokemon.id),
            ),
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
