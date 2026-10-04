import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/pokemon_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PokemonProvider()..fetchPokemon(),
      child: const PokedexApp(),
    ),
  );
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ),
        useMaterial3: true,
      ),
      home: const PokemonListScreen(),
    );
  }
}

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();

    if (provider.isLoading && provider.pokemon.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (provider.errorMessage != null && provider.pokemon.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(provider.errorMessage!),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
      ),
      body: ListView.builder(
        itemCount: provider.pokemon.length,
        itemBuilder: (context, index) {
          final pokemon = provider.pokemon[index];

          return ListTile(
            leading: Image.network(
              pokemon.imageUrl,
              width: 60,
              height: 60,
            ),
            title: Text(
              pokemon.name.toUpperCase(),
            ),
            subtitle: Text('#${pokemon.id}'),
          );
        },
      ),
    );
  }
}