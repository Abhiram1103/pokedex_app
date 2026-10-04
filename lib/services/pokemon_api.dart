import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';

class PokemonPage {
  final List<Pokemon> pokemon;
  final String? nextUrl;

  const PokemonPage({required this.pokemon, required this.nextUrl});
}

class PokemonApi {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<PokemonPage> fetchPokemon({int limit = 20, int offset = 0}) async {
    final uri = Uri.parse('$_baseUrl/pokemon?limit=$limit&offset=$offset');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load Pokémon. '
        'Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final results = data['results'] as List<dynamic>;

    final pokemon = results
        .map((item) => Pokemon.fromApiResponse(item as Map<String, dynamic>))
        .toList();

    return PokemonPage(pokemon: pokemon, nextUrl: data['next'] as String?);
  }

  Future<PokemonPage> fetchPokemonFromUrl(String url) async {
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load Pokémon. '
        'Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final results = data['results'] as List<dynamic>;

    final pokemon = results
        .map((item) => Pokemon.fromApiResponse(item as Map<String, dynamic>))
        .toList();

    return PokemonPage(pokemon: pokemon, nextUrl: data['next'] as String?);
  }

  Future<PokemonDetail> fetchPokemonDetail(String name) async {
    final uri = Uri.parse('$_baseUrl/pokemon/$name');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load Pokémon details. '
        'Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return PokemonDetail.fromApiResponse(data);
  }
}
