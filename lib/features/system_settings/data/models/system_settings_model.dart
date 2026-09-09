class SystemSettingsModel {
  final int id;
  final double creditHourPrice;

  /// The example JSON response only shows `credit_hour_price`, but
  /// the resource's source (visible in the docs as a stray PHP
  /// fragment) also returns these three — kept nullable since we
  /// haven't seen a live response confirming their exact keys/types.
  final int? minimumCreditHours;
  final int? maximumCreditHours;
  final double? passingGrade;

  final String createdAt;

  const SystemSettingsModel({
    required this.id,
    required this.creditHourPrice,
    required this.minimumCreditHours,
    required this.maximumCreditHours,
    required this.passingGrade,
    required this.createdAt,
  });

  factory SystemSettingsModel.fromJson(Map<String, dynamic> json) {
    return SystemSettingsModel(
      id: _asInt(json['id']),
      creditHourPrice: _asDouble(json['credit_hour_price']) ?? 0,
      minimumCreditHours: _asIntOrNull(json['minimum_credit_hours']),
      maximumCreditHours: _asIntOrNull(json['maximum_credit_hours']),
      passingGrade: _asDouble(json['passing_grade']),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _asIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _asDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
