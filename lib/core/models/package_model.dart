import 'package:yalla/core/models/facility_model.dart';

class PackageModel {
  final String? id;
  final String batchDate;
  final String batchName;
  final int durationDays;
  final String packageName;
  final int price;
  final String travelUserId;
  final List<FacilityModel>? facilities;

  PackageModel({
    this.id,
    required this.batchDate,
    required this.batchName,
    required this.durationDays,
    required this.packageName,
    required this.price,
    required this.travelUserId,
    this.facilities,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      batchDate: json['batch_date'] ?? '',
      batchName: json['batch_name'] ?? '',
      durationDays: json['duration_days'] ?? 0,
      packageName: json['package_name'] ?? '',
      price: json['price'] ?? 0,
      travelUserId: json['travel_user_id'] ?? '',
      facilities: json['facilities'] != null
          ? List<FacilityModel>.from(
              json['facilities'].map((f) => FacilityModel.fromJson(f)),
            )
          : [],
    );
  }
}
