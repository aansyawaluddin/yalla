class AdminStatsModel {
  final int totalOrders;
  final int totalJamaah;
  final int totalTravel;
  final int totalPackages;
  final List<DailyOrderModel> dailyOrders;
  final List<LatestOrderModel> latestOrders;

  AdminStatsModel({
    required this.totalOrders,
    required this.totalJamaah,
    required this.totalTravel,
    required this.totalPackages,
    required this.dailyOrders,
    required this.latestOrders,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      totalOrders: json['total_orders'] ?? 0,
      totalJamaah: json['total_jamaah'] ?? 0,
      totalTravel: json['total_travel'] ?? 0,
      totalPackages: json['total_packages'] ?? 0,
      dailyOrders: (json['daily_orders'] as List<dynamic>? ?? [])
          .map((e) => DailyOrderModel.fromJson(e))
          .toList(),
      latestOrders: (json['latest_orders'] as List<dynamic>? ?? [])
          .map((e) => LatestOrderModel.fromJson(e))
          .toList(),
    );
  }

  static AdminStatsModel empty() => AdminStatsModel(
    totalOrders: 0,
    totalJamaah: 0,
    totalTravel: 0,
    totalPackages: 0,
    dailyOrders: [],
    latestOrders: [],
  );
}

class DailyOrderModel {
  final String date;
  final int count;

  DailyOrderModel({required this.date, required this.count});

  factory DailyOrderModel.fromJson(Map<String, dynamic> json) {
    return DailyOrderModel(date: json['date'] ?? '', count: json['count'] ?? 0);
  }
}

class LatestOrderModel {
  final String id;
  final String status;
  final num price;
  final String email;
  final String flightNo;
  final bool isPackage;
  final String packageName;
  final int passengerCount;
  final String createdAt;

  LatestOrderModel({
    required this.id,
    required this.status,
    required this.price,
    required this.email,
    required this.flightNo,
    required this.isPackage,
    required this.packageName,
    required this.passengerCount,
    required this.createdAt,
  });

  factory LatestOrderModel.fromJson(Map<String, dynamic> json) {
    final package = json['package'];
    final departureFlight = json['departure_flight'];
    final passengers = json['passengers'] as List<dynamic>? ?? [];

    return LatestOrderModel(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      price: json['price'] ?? 0,
      email: json['email'] ?? '',
      flightNo: package != null
          ? (package['departure_flight']?['flightNo'] ?? '-')
          : (departureFlight?['flightNo'] ?? '-'),
      isPackage: package != null,
      packageName: package?['package_name'] ?? '',
      passengerCount: passengers.length,
      createdAt: json['created_at'] ?? '',
    );
  }
}
