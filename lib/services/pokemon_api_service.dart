import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon_detail.dart';
import '../models/pokemon_page.dart';

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class PokemonApiService {
  PokemonApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _baseUrl = 'https://pokeapi.co/api/v2';

  /// [nextUrl] null ho to pehla page aata hai.
  Future<PokemonPage> fetchPage({String? nextUrl}) async {
    final url = nextUrl ?? '$_baseUrl/pokemon?limit=20&offset=0';
    return PokemonPage.fromJson(await _getJson(url));
  }

  Future<PokemonDetail> fetchDetail(int id) async {
    return PokemonDetail.fromJson(await _getJson('$_baseUrl/pokemon/$id'));
  }

  Future<Map<String, dynamic>> _getJson(String url) async {
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw ApiException('Server error (${response.statusCode})');
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        'Could not load data. Please check your internet connection.',
      );
    }
  }
}
