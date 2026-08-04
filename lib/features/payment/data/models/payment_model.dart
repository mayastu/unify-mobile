import '../../../profile/data/models/student_model.dart';

class PaymentModel {
  final String id;
  final StudentModel student;
  final String amount;
  final String paymentMethod;
  final String referenceNumber;
  final String paymentDate;
  final String createdAt;

  const PaymentModel({
    required this.id,
    required this.student,
    required this.amount,
    required this.paymentMethod,
    required this.referenceNumber,
    required this.paymentDate,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json["id"].toString(),
      student: StudentModel.fromJson(json["student"]),
      amount: json["amount"].toString(),
      paymentMethod: json["payment_method"]?.toString() ?? '',
      referenceNumber: json["reference_number"]?.toString() ?? '',
      paymentDate: json["payment_date"]?.toString() ?? '',
      createdAt: json["created_at"]?.toString() ?? '',
    );
  }
}