class RatingStatsModel {
  final double averageScore;
  final int totalRatings;

  RatingStatsModel({required this.averageScore, required this.totalRatings});

  factory RatingStatsModel.fromJson(Map<String, dynamic> json) {
    return RatingStatsModel(
      averageScore: (json['average_score'] ?? 0).toDouble(),
      totalRatings: json['total_ratings'] ?? 0,
    );
  }

  static RatingStatsModel empty() =>
      RatingStatsModel(averageScore: 0, totalRatings: 0);
}
