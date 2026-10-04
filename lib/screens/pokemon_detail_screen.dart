import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';
import '../services/pokemon_api.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({
    super.key,
    required this.pokemon,
  });

  @override
  State<PokemonDetailScreen> createState() =>
      _PokemonDetailScreenState();
}

class _PokemonDetailScreenState
    extends State<PokemonDetailScreen> {
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
      final detail = await _api.fetchPokemonDetail(
        widget.pokemon.name,
      );

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
      title: Text(
      _capitalize(widget.pokemon.name),
    ),
    actions: [
      Consumer<FavoritesProvider>(
        builder: (context, favorites, child) {
          final isFavorite =
              favorites.isFavorite(widget.pokemon.id);

          return IconButton(
            onPressed: () {
              favorites.toggleFavorite(widget.pokemon);
            },
            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final pokemon = _pokemonDetail;

    if (pokemon == null) {
      return const Center(
        child: Text('No Pokémon details available.'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              pokemon.imageUrl,
              height: 250,
              width: 250,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              '#${pokemon.id.toString().padLeft(3, '0')}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ),

          const SizedBox(height: 4),

          Center(
            child: Text(
              _capitalize(pokemon.name),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
            (ability) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '• ${_capitalize(ability)}',
              ),
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Base Stats'),

          const SizedBox(height: 12),

          ...pokemon.stats.map(
            (stat) => _buildStatRow(stat),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(PokemonStat stat) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              _formatStatName(stat.name),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: stat.value / 255,
              minHeight: 8,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 35,
            child: Text(
              stat.value.toString(),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatName(String value) {
    return value
        .split('-')
        .map(_capitalize)
        .join(' ');
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}