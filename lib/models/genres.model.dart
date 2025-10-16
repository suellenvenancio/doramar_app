class Genre {
  final String id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromMap(Map<String, dynamic> json) {
    return Genre(id: json['id'], name: json['name']);
  }
}
