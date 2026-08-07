import '../../../profile/data/models/student_model.dart';

class HourPurchaseModel {
  final int id;
  final StudentModel student;
  final int creditHours;
  final  String pricePerHour;
  final String totalAmount;
  final String createdAt;

  const HourPurchaseModel({
    required this.id,
    required this.student,
    required this.creditHours,
    required this.pricePerHour,
    required this.totalAmount,
    required this.createdAt,
  });

  factory HourPurchaseModel.fromJson(Map<String, dynamic> json) {
    return HourPurchaseModel(
      id: json['id'],
      student: StudentModel.fromJson(json['student']),
      creditHours: json['credit_hours'],
      pricePerHour: json['price_per_hour'],
      totalAmount:json['total_amount'],
      createdAt: json['created_at'],
    );
  }
}