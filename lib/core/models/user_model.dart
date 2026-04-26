class UserModel {
  final String? email;
  final UserProfile? profile;
  final String? role;
  final String? userID;

  UserModel({this.email, this.profile, this.role, this.userID});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String?,
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'])
          : null,
      role: json['role'] as String?,
      userID: json['userID'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'profile': profile?.toJson(),
      'role': role,
      'userID': userID,
    };
  }
}

class UserProfile {
  final String? birth;
  final String? firstName;
  final String? gender;
  final String? lastName;
  final String? nationality;

  UserProfile({
    this.birth,
    this.firstName,
    this.gender,
    this.lastName,
    this.nationality,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      birth: json['birth'] as String?,
      firstName: json['firstName'] as String?,
      gender: json['gender'] as String?,
      lastName: json['lastName'] as String?,
      nationality: json['nationality'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'birth': birth,
      'firstName': firstName,
      'gender': gender,
      'lastName': lastName,
      'nationality': nationality,
    };
  }
}
