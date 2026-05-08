class PackageModel {
  final String? id;
  final String batchDate;
  final String packageName;
  final int durationDays;
  final String batchName;
  final int price;

  PackageModel({
    this.id,
    required this.batchDate,
    required this.packageName,
    required this.durationDays,
    required this.batchName,
    required this.price,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      batchDate: json['batch_date'] ?? '',
      packageName: json['package_name'] ?? '',
      durationDays: json['duration_days'] ?? 0,
      batchName: json['batch_name'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "batch_date": batchDate,
      "package_name": packageName,
      "duration_days": durationDays,
      "batch_name": batchName,
      "price": price,
    };
  }
}