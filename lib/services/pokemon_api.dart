import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonApi {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemon({
    int limit = 20,
    int offset = 0,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/pokemon?limit=$limit&offset=$offset',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load Pokémon. Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final results = data['results'] as List<dynamic>;

    return results
        .map(
          (pokemon) =>
              Pokemon.fromApiResponse(pokemon as Map<String, dynamic>),
        )
        .toList();
  }
}