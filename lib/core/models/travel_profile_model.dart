class TravelProfileModel {
  final String userID;
  final String email;
  final double averageScore;
  final int totalRatings;
  final String firstName;
  final String lastName;
  final String aboutText;
  final String licenseNumber;
  final String operatingSince;

  TravelProfileModel({
    required this.userID,
    required this.email,
    required this.averageScore,
    required this.totalRatings,
    required this.firstName,
    required this.lastName,
    required this.aboutText,
    required this.licenseNumber,
    required this.operatingSince,
  });

  factory TravelProfileModel.fromJson(Map<String, dynamic> json) {
    return TravelProfileModel(
      userID: json['userID'] ?? '',
      email: json['email'] ?? '',
      averageScore: (json['average_score'] ?? 0).toDouble(),
      totalRatings: json['total_ratings'] ?? 0,
      firstName: json['profile']?['firstName'] ?? '',
      lastName: json['profile']?['lastName'] ?? '',
      aboutText:
          json['travel_details']?['about_text'] ??
          'Belum ada deskripsi profil untuk travel ini.',
      licenseNumber: json['travel_details']?['license_number'] ?? '-',
      operatingSince: json['travel_details']?['operating_since'] ?? '-',
    );
  }

  String get companyName => "$firstName $lastName".trim();
  String get operatingYear => operatingSince.length >= 4
      ? operatingSince.substring(0, 4)
      : operatingSince;
}
