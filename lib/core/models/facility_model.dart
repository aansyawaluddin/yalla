class FacilityModel {
  final String id;
  final String name;
  final String slug;

  FacilityModel({required this.id, required this.name, required this.slug});

  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    return FacilityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}
