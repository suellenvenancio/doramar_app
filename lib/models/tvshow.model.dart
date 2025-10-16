import 'genres.model.dart';

class TvShow {
  final String id;
  final String title;
  final String synopsis;
  final String cast;
  final String poster;
  final DateTime premiereDate;
  final String originalName;
  final DateTime createdAt;
  final List<Genre>? genres;

  TvShow({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.cast,
    required this.poster,
    required this.premiereDate,
    required this.originalName,
    required this.createdAt,
    required this.genres,
  });

  factory TvShow.fromMap(Map<String, dynamic> map) {
    return TvShow(
      id: map['id'],
      title: map['title'],
      synopsis: map['synopsis'],
      cast: map['cast'],
      poster: map['poster'],
      premiereDate: DateTime.parse(map['premiereDate']),
      originalName: map['originalName'],
      createdAt: DateTime.parse(map['createdAt']),
      genres: (map['genres'] as List<dynamic>?)
          ?.map((item) => Genre.fromMap(item))
          .toList(),
    );
  }
}
