import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pokemon.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String _favoritesKey = 'favorite_pokemon_ids';

  final Set<int> _favoriteIds = {};

  bool _isInitialized = false;

  Set<int> get favoriteIds => Set.unmodifiable(_favoriteIds);

  bool get isInitialized => _isInitialized;

  bool isFavorite(int pokemonId) {
    return _favoriteIds.contains(pokemonId);
  }

  Future<void> loadFavorites() async {
    final preferences = await SharedPreferences.getInstance();

    final savedIds = preferences.getStringList(_favoritesKey) ?? [];

    _favoriteIds
      ..clear()
      ..addAll(savedIds.map(int.parse));

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> toggleFavorite(Pokemon pokemon) async {
    if (_favoriteIds.contains(pokemon.id)) {
      _favoriteIds.remove(pokemon.id);
    } else {
      _favoriteIds.add(pokemon.id);
    }

    notifyListeners();

    final preferences = await SharedPreferences.getInstance();

    await preferences.setStringList(
      _favoritesKey,
      _favoriteIds.map((id) => id.toString()).toList(),
    );
  }

  List<Pokemon> getFavorites(List<Pokemon> allPokemon) {
    return allPokemon
        .where((pokemon) => _favoriteIds.contains(pokemon.id))
        .toList();
  }
}
