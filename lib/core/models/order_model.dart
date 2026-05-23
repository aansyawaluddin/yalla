import 'package:yalla/core/models/flight_model.dart';

class PaymentDetailModel {
  final String? gatewayOrderId;
  final String? gatewayUrl;

  PaymentDetailModel({this.gatewayOrderId, this.gatewayUrl});

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailModel(
      gatewayOrderId: json['gateway_order_id'],
      gatewayUrl: json['gateway_url'],
    );
  }
}

class PassengerModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? dateOfBirth;
  final String? passportNumber;
  final String? passportIssueDate;
  final String? passportExpiryDate;

  PassengerModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.dateOfBirth,
    this.passportNumber,
    this.passportIssueDate,
    this.passportExpiryDate,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      dateOfBirth: json['date_of_birth'],
      passportNumber: json['passport_number'],
      passportIssueDate: json['passport_issue_date'],
      passportExpiryDate: json['passport_expiry_date'],
    );
  }
}

class OrderModel {
  final String id;
  final String buyerId;
  final String status;
  final String? email;
  final String? phoneNumber;
  final String departureFlightId;
  final String? returnFlightId;
  final num price;
  final String createdAt;
  final String updatedAt;
  final PaymentDetailModel? payment;
  final List<PassengerModel> passengers;
  final FlightModel? flight;
  final FlightModel? returnFlight;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.status,
    this.email,
    this.phoneNumber,
    required this.departureFlightId,
    this.returnFlightId,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    this.payment,
    required this.passengers,
    this.flight,
    this.returnFlight,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var passengersList = json['passengers'] as List? ?? [];
    List<PassengerModel> mappedPassengers = passengersList
        .map((p) => PassengerModel.fromJson(p))
        .toList();

    return OrderModel(
      id: json['id'] ?? '',
      buyerId: json['buyer_id'] ?? '',
      status: json['status'] ?? 'waiting_payment',
      email: json['email'],
      phoneNumber: json['phone_number'],
      departureFlightId: json['departure_flight_id'] ?? '',
      returnFlightId: json['return_flight_id'],
      price: json['price'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      payment: json['payment'] != null
          ? PaymentDetailModel.fromJson(json['payment'])
          : null,
      passengers: mappedPassengers,
      flight: json['departure_flight'] != null
          ? FlightModel.fromJson(json['departure_flight'])
          : (json['flight'] != null
                ? FlightModel.fromJson(json['flight'])
                : null),
      returnFlight:
          json['return_flight'] !=
              null
          ? FlightModel.fromJson(json['return_flight'])
          : null,
    );
  }
}
