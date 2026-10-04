import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';
import '../services/pokemon_api.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final PokemonApi _api = PokemonApi();

  PokemonDetail? _pokemonDetail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPokemonDetail();
  }

  Future<void> _loadPokemonDetail() async {
    try {
      final detail = await _api.fetchPokemonDetail(widget.pokemon.name);

      if (!mounted) {
        return;
      }

      setState(() {
        _pokemonDetail = detail;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Failed to load Pokémon details.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_capitalize(widget.pokemon.name)),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favorites, child) {
              final isFavorite = favorites.isFavorite(widget.pokemon.id);

              return IconButton(
                onPressed: () {
                  favorites.toggleFavorite(widget.pokemon);
                },
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_errorMessage!, textAlign: TextAlign.center),
        ),
      );
    }

    final pokemon = _pokemonDetail;

    if (pokemon == null) {
      return const Center(child: Text('No Pokémon details available.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                Image.network(
                  pokemon.imageUrl,
                  height: 240,
                  width: 240,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 240,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _capitalize(pokemon.name),
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _buildSectionTitle('Types'),

          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pokemon.types
                .map(
                  (type) => Chip(
                    label: Text(
                      _capitalize(type),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    backgroundColor: _typeColor(type),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Physical Information'),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'Height',
                  '${pokemon.height.toStringAsFixed(1)} m',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  'Weight',
                  '${pokemon.weight.toStringAsFixed(1)} kg',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Abilities'),

          const SizedBox(height: 8),

          ...pokemon.abilities.map(
            (ability) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_awesome, size: 20),
                  ),

                  const SizedBox(width: 12),

                  Text(
                    _capitalize(ability),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Base Stats'),

          const SizedBox(height: 12),

          ...pokemon.stats.map((stat) => _buildStatRow(stat)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge
          ?.copyWith(fontWeight: FontWeight.w800, fontSize: 20),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    final IconData icon = label == 'Height'
        ? Icons.height
        : Icons.monitor_weight_outlined;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.grey.shade700),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(PokemonStat stat) {
    final progress = (stat.value / 255).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              _formatStatName(stat.name),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ),

          const SizedBox(width: 12),

          SizedBox(
            width: 35,
            child: Text(
              stat.value.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatName(String value) {
    return value.split('-').map(_capitalize).join(' ');
  }

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return Colors.grey;
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'electric':
        return Colors.amber.shade700;
      case 'grass':
        return Colors.green;
      case 'ice':
        return Colors.cyan;
      case 'fighting':
        return Colors.deepOrange;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown;
      case 'flying':
        return Colors.indigo.shade300;
      case 'psychic':
        return Colors.pink;
      case 'bug':
        return Colors.lightGreen.shade700;
      case 'rock':
        return Colors.brown.shade700;
      case 'ghost':
        return Colors.deepPurple;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.grey.shade800;
      case 'steel':
        return Colors.blueGrey;
      case 'fairy':
        return Colors.pink.shade300;
      default:
        return Colors.grey;
    }
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}
