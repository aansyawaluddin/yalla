class TravelDetailModel {
  final String id;
  final String userId;
  final String aboutText;
  final String licenseNumber;
  final String operatingSince;

  TravelDetailModel({
    required this.id,
    required this.userId,
    required this.aboutText,
    required this.licenseNumber,
    required this.operatingSince,
  });

  factory TravelDetailModel.fromJson(Map<String, dynamic> json) {
    return TravelDetailModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      aboutText: json['about_text'] ?? 'Belum ada deskripsi.',
      licenseNumber: json['license_number'] ?? '-',
      operatingSince: json['operating_since'] ?? '-',
    );
  }

  String get operatingYear {
    if (operatingSince.length >= 4) {
      return operatingSince.substring(0, 4);
    }
    return operatingSince;
  }
}
