import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final pokemonProvider = context.watch<PokemonProvider>();

    final favoritePokemon = favorites.getFavorites(pokemonProvider.pokemon);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favoritePokemon.isEmpty
          ? const Center(child: Text('No favorite Pokémon yet.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favoritePokemon.length,
              itemBuilder: (context, index) {
                final pokemon = favoritePokemon[index];

                return PokemonCard(
                  pokemon: pokemon,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PokemonDetailScreen(pokemon: pokemon),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
