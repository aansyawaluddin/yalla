class PackagePassengerModel {
  final String id;
  final String orderId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String passportNumber;
  final String passportIssueDate;
  final String passportExpiryDate;
  final int passportCountryId;
  final String createdAt;

  PackagePassengerModel({
    required this.id,
    required this.orderId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.passportNumber,
    required this.passportIssueDate,
    required this.passportExpiryDate,
    required this.passportCountryId,
    required this.createdAt,
  });

  factory PackagePassengerModel.fromJson(Map<String, dynamic> json) {
    return PackagePassengerModel(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      passportNumber: json['passport_number'] ?? '',
      passportIssueDate: json['passport_issue_date'] ?? '',
      passportExpiryDate: json['passport_expiry_date'] ?? '',
      passportCountryId: json['passport_country_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
}
