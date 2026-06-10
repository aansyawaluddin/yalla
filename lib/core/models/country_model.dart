class CountryModel {
  final int id;
  final String country;
  final String countryCode;

  CountryModel({
    required this.id,
    required this.country,
    required this.countryCode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as int,
      country: json['country'] as String,
      countryCode: json['country_code'] as String,
    );
  }
}
