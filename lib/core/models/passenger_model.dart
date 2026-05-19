class PassengerModel {
  final String? id;
  final String? orderId;
  final String? fullName;
  final String? gender;
  final String? email;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? passportNumber;
  final String? passportIssueDate;
  final String? passportExpiryDate;
  final int? passportCountryId;
  final String? createdAt;
  final String? updatedAt;

  PassengerModel({
    this.id,
    this.orderId,
    this.fullName,
    this.gender,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.passportNumber,
    this.passportIssueDate,
    this.passportExpiryDate,
    this.passportCountryId,
    this.createdAt,
    this.updatedAt,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      id: json['id'],
      orderId: json['order_id'],
      fullName: json['full_name'],
      gender: json['gender'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      dateOfBirth: json['date_of_birth'],
      passportNumber: json['passport_number'],
      passportIssueDate: json['passport_issue_date'],
      passportExpiryDate: json['passport_expiry_date'],
      passportCountryId: json['passport_country_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
