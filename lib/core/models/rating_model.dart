class RatingModel {
  final String id;
  final String rateeId;
  final String raterId;
  final String raterFullName;
  final String raterAvatarUrl;
  final int score;
  final String comment;
  final String createdAt;

  RatingModel({
    required this.id,
    required this.rateeId,
    required this.raterId,
    required this.raterFullName,
    required this.raterAvatarUrl,
    required this.score,
    required this.comment,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] ?? '',
      rateeId: json['ratee_id'] ?? '',
      raterId: json['rater_id'] ?? '',
      raterFullName: json['rater_full_name'] ?? '',
      raterAvatarUrl: json['rater_avatar_url'] ?? '',
      score: json['score'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
