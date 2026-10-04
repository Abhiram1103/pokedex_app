import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';
import '../services/pokemon_api.dart';

class PokemonProvider extends ChangeNotifier {
  final PokemonApi _api = PokemonApi();

  final List<Pokemon> _pokemon = [];

  bool _isLoading = false;
  bool _hasMore = true;
  String? _errorMessage;

  List<Pokemon> get pokemon => List.unmodifiable(_pokemon);
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPokemon() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final page = await _api.fetchPokemon(
        limit: 20,
        offset: _pokemon.length,
      );

      _pokemon.addAll(page.pokemon);

      _hasMore = page.nextUrl != null;
    } catch (e) {
      _errorMessage = 'Failed to load Pokémon.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}