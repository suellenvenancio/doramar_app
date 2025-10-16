import 'rating_scale.model.dart';
import 'tvshow.model.dart';
import 'user.model.dart';

class Rating {
  final String id;
  final String userId;
  final String tvShowId;
  final int scaleId;
  final RatingScale scale;
  final TvShow? tvShow;
  final User? user;

  Rating({
    required this.id,
    required this.userId,
    required this.tvShowId,
    required this.scaleId,

    required this.scale,
    this.tvShow,
    this.user,
  });
  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      id: map['id'],
      userId: map['userId'],
      tvShowId: map['tvShowId'],
      scaleId: map['scaleId'],
      scale: RatingScale.fromMap(map['scale']),
      tvShow: map['tvShow'] != null ? TvShow.fromMap(map['tvShow']) : null,
      user: map['user'] != null ? User.fromMap(map['user']) : null,
    );
  }
}
