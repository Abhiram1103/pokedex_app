class PokemonDetail {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final double height;
  final double weight;
  final List<String> abilities;
  final List<PokemonStat> stats;

  const PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.stats,
  });

  factory PokemonDetail.fromApiResponse(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>;

    final other = sprites['other'] as Map<String, dynamic>?;

    final artwork = other?['official-artwork'] as Map<String, dynamic>?;

    final imageUrl = artwork?['front_default'] as String? ?? '';

    final types = (json['types'] as List<dynamic>).map((item) {
      final typeData = item as Map<String, dynamic>;

      final type = typeData['type'] as Map<String, dynamic>;

      return type['name'] as String;
    }).toList();

    final abilities = (json['abilities'] as List<dynamic>).map((item) {
      final abilityData = item as Map<String, dynamic>;

      final ability = abilityData['ability'] as Map<String, dynamic>;

      return ability['name'] as String;
    }).toList();

    final stats = (json['stats'] as List<dynamic>)
        .map(
          (item) => PokemonStat.fromApiResponse(item as Map<String, dynamic>),
        )
        .toList();

    return PokemonDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: imageUrl,
      types: types,
      height: (json['height'] as num) / 10,
      weight: (json['weight'] as num) / 10,
      abilities: abilities,
      stats: stats,
    );
  }
}

class PokemonStat {
  final String name;
  final int value;

  const PokemonStat({required this.name, required this.value});

  factory PokemonStat.fromApiResponse(Map<String, dynamic> json) {
    final statData = json['stat'] as Map<String, dynamic>;

    return PokemonStat(
      name: statData['name'] as String,
      value: json['base_stat'] as int,
    );
  }
}
