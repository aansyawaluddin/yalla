class UserProfileModel {
  final String userID;
  final String email;
  final String role;
  final String avatarUrl;
  final String firstName;
  final String lastName;
  final String birth;
  final String gender;
  final String nationality;

  UserProfileModel({
    required this.userID,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.firstName,
    required this.lastName,
    required this.birth,
    required this.gender,
    required this.nationality,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>? ?? {};
    return UserProfileModel(
      userID: json['userID'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      avatarUrl: profile['avatarUrl'] ?? '',
      firstName: profile['firstName'] ?? '',
      lastName: profile['lastName'] ?? '',
      birth: profile['birth'] ?? '',
      gender: profile['gender'] ?? '',
      nationality: profile['nationality'] ?? '',
    );
  }

  factory UserProfileModel.empty() {
    return UserProfileModel(
      userID: '',
      email: '',
      role: '',
      avatarUrl: '',
      firstName: '',
      lastName: '',
      birth: '',
      gender: '',
      nationality: '',
    );
  }
}
