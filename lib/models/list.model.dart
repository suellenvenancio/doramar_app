import 'tvshow.model.dart';

class ListModel {
  final String id;
  final String name;
  final String userId;
  final List<TvShow> tvShows;
  final DateTime createdAt;
  final DateTime updatedAt;

  ListModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.tvShows,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      id: map['id'],
      name: map['name'],
      userId: map['userId'],
      tvShows: map['tvShows'] != null
          ? (map['tvShows'] as List)
                .map((item) => TvShow.fromMap(item as Map<String, dynamic>))
                .toList()
          : [],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
