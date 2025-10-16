class Actor {
  final String id;
  final String name;

  Actor({required this.id, required this.name});

  factory Actor.fromMap(Map<String, dynamic> json) {
    return Actor(id: json['id'], name: json['name']);
  }
}
