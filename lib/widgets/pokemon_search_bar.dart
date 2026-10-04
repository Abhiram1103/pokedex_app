import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';

class PokemonSearchBar extends StatelessWidget {
  const PokemonSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PokemonProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        onChanged: provider.setSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search Pokémon...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Consumer<PokemonProvider>(
            builder: (context, provider, child) {
              if (provider.searchQuery.isEmpty) {
                return const SizedBox.shrink();
              }

              return IconButton(
                onPressed: () {
                  provider.setSearchQuery('');
                },
                icon: const Icon(Icons.clear),
              );
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}