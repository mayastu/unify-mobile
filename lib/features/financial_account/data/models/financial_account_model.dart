
import '../../../profile/data/models/student_model.dart';

class FinancialAccountModel {
  final int id;
  final StudentModel student;
  final String availableBalance;
  final String purchasedCreditHours;
  final String usedCreditHours;
  final String remainingCreditHours;
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
      id: json['id'],
      student: StudentModel.fromJson(json['student']),
      availableBalance: json['available_balance'],
      purchasedCreditHours: json['purchased_credit_hours'],
      usedCreditHours: json['used_credit_hours'],
      remainingCreditHours: json['remaining_credit_hours'],
      createdAt: json['created_at'],
    );
  }
}