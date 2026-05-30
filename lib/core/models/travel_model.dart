class TravelModel {
  final String userID;
  final String email;
  final double averageScore;
  final int totalRatings;
  final String firstName;
  final String lastName;
  final String avatarUrl; 

  TravelModel({
    required this.userID,
    required this.email,
    required this.averageScore,
    required this.totalRatings,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl, 
  });

  factory TravelModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>? ?? {};
    return TravelModel(
      userID: json['userID'] ?? '',
      email: json['email'] ?? '',
      averageScore: (json['average_score'] ?? 0).toDouble(),
      totalRatings: json['total_ratings'] ?? 0,
      firstName: profile['firstName'] ?? '',
      lastName: profile['lastName'] ?? '',
      avatarUrl: profile['avatarUrl'] ?? '', 
    );
  }

  String get fullName => "$firstName $lastName".trim();
}
