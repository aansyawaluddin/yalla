class FlightModel {
  final String? id;
  final String? departureTime;
  final String? flightNo;
  final String? arrivalTime;
  final int? economyClass;
  final int? businessClass;
  final double? price;
  final bool? isOutbound;
  final int? passengersCount; 

  FlightModel({
    this.id,
    this.departureTime,
    this.flightNo,
    this.arrivalTime,
    this.economyClass,
    this.businessClass,
    this.price,
    this.isOutbound,
    this.passengersCount, 
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['ID'] as String? ?? json['id'] as String?,
      departureTime:
          json['DepartureTime'] as String? ?? json['departureTime'] as String?,
      flightNo: json['FlightNo'] as String? ?? json['flightNo'] as String?,
      arrivalTime:
          json['ArrivalTime'] as String? ?? json['arrivalTime'] as String?,
      economyClass:
          json['EconomyClass'] as int? ?? json['economyClass'] as int?,
      businessClass:
          json['BusinessClass'] as int? ?? json['businessClass'] as int?,
      price: (json['Price'] ?? json['price']) != null
          ? ((json['Price'] ?? json['price']) as num).toDouble()
          : null,
      isOutbound: json['IsOutbound'] as bool? ?? json['isOutbound'] as bool?,
      passengersCount:
          json['passengers_count'] as int? ??
          json['passengersCount'] as int?, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'DepartureTime': departureTime,
      'FlightNo': flightNo,
      'ArrivalTime': arrivalTime,
      'EconomyClass': economyClass,
      'BusinessClass': businessClass,
      'Price': price,
      'IsOutbound': isOutbound,
      'passengers_count': passengersCount, 
    };
  }
}
