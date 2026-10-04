import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<int> _favoriteIds = {};

  Set<int> get favoriteIds => Set.unmodifiable(_favoriteIds);

  bool isFavorite(int pokemonId) {
    return _favoriteIds.contains(pokemonId);
  }

  void toggleFavorite(Pokemon pokemon) {
    if (_favoriteIds.contains(pokemon.id)) {
      _favoriteIds.remove(pokemon.id);
    } else {
      _favoriteIds.add(pokemon.id);
    }

    notifyListeners();
  }

  List<Pokemon> getFavorites(List<Pokemon> allPokemon) {
    return allPokemon
        .where((pokemon) => _favoriteIds.contains(pokemon.id))
        .toList();
  }
}