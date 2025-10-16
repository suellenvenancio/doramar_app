class RatingScale {
  int id;
  String label;

  RatingScale({required this.id, required this.label});

  factory RatingScale.fromMap(Map<String, dynamic> map) {
    return RatingScale(id: map['id'], label: map['label']);
  }
}
