import 'package:yalla/core/models/facility_model.dart';
import 'package:yalla/core/models/flight_model.dart'; // 👇 Pastikan ini di-import

class PackageModel {
  final String? id;
  final String batchDate;
  final String batchName;
  final int durationDays;
  final String packageName;
  final int price;
  final String travelUserId;
  final List<FacilityModel>? facilities;

  final FlightModel? departureFlight;
  final FlightModel? returnFlight;

  PackageModel({
    this.id,
    required this.batchDate,
    required this.batchName,
    required this.durationDays,
    required this.packageName,
    required this.price,
    required this.travelUserId,
    this.facilities,
    this.departureFlight,
    this.returnFlight,
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
      departureFlight: json['departure_flight'] != null
          ? FlightModel.fromJson(json['departure_flight'])
          : null,
      returnFlight: json['return_flight'] != null
          ? FlightModel.fromJson(json['return_flight'])
          : null,
    );
  }
}
