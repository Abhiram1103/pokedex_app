class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  const Pokemon({required this.id, required this.name, required this.imageUrl});

  factory Pokemon.fromApiResponse(Map<String, dynamic> json) {
    final url = json['url'] as String;

    final id = int.parse(url.split('/').where((part) => part.isNotEmpty).last);

    return Pokemon(
      id: id,
      name: json['name'] as String,
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }
}
