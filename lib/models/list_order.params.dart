class ListOrder {
  final String tvShowId;
  final String listId;
  final int order;
  final String? userId;

  ListOrder({
    required this.tvShowId,
    required this.listId,
    required this.order,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'tvShowId': tvShowId,
      'listId': listId,
      'order': order,
      'userId': userId,
    };
  }
}
