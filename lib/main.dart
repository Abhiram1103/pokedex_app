import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/pokemon_card.dart';
import 'providers/pokemon_provider.dart';
import 'screens/pokemon_detail_screen.dart';
import 'providers/favorites_provider.dart';
import 'screens/favorites_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PokemonProvider()..fetchPokemon(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(),
        ),
      ],
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
      home: const HomeScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PokemonListScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.catching_pokemon),
            label: 'Pokémon',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
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
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            final metrics = notification.metrics;

            if (metrics.pixels >= metrics.maxScrollExtent - 200) {
              provider.fetchPokemon();
            }
          }

          return false;
        },
        child: ListView.builder(
          itemCount:
              provider.pokemon.length + (provider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == provider.pokemon.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final pokemon = provider.pokemon[index];

            return PokemonCard(
              pokemon: pokemon,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PokemonDetailScreen(
                      pokemon: pokemon,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}