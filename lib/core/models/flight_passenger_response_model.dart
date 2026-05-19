import 'package:yalla/core/models/flight_model.dart';
import 'package:yalla/core/models/passenger_model.dart';

class FlightPassengerResponseModel {
  final FlightModel? flight;
  final int passengersCount;
  final List<PassengerModel> passengers;

  FlightPassengerResponseModel({
    this.flight,
    this.passengersCount = 0,
    required this.passengers,
  });

  factory FlightPassengerResponseModel.fromJson(Map<String, dynamic> json) {
    return FlightPassengerResponseModel(
      flight: json['flight'] != null
          ? FlightModel.fromJson(json['flight'])
          : null,
      passengersCount: json['passengers_count'] ?? 0,
      passengers: json['passengers'] != null
          ? List<PassengerModel>.from(
              json['passengers'].map((x) => PassengerModel.fromJson(x)),
            )
          : [],
    );
  }
}
