import '../../../profile/data/models/student_model.dart';

class FinancialAccountModel {
  final int id;
  final StudentModel student;
  final double availableBalance;
  final int purchasedCreditHours;
  final int usedCreditHours;
  final int remainingCreditHours;
  final String createdAt;

  const FinancialAccountModel({
    required this.id,
    required this.student,
    required this.availableBalance,
    required this.purchasedCreditHours,
    required this.usedCreditHours,
    required this.remainingCreditHours,
    required this.createdAt,
  });

  factory FinancialAccountModel.fromJson(Map<String, dynamic> json) {
    return FinancialAccountModel(
      id: int.parse(json['id'].toString()),
      student: StudentModel.fromJson(json['student']),
      availableBalance: double.parse(json['available_balance'].toString()),
      purchasedCreditHours:
      int.parse(json['purchased_credit_hours'].toString()),
      usedCreditHours:
      int.parse(json['used_credit_hours'].toString()),
      remainingCreditHours:
      int.parse(json['remaining_credit_hours'].toString()),
      createdAt: json['created_at'].toString(),
    );
  }
}