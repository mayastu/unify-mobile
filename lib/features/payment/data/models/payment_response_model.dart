import 'payment_model.dart';

class PaymentResponseModel {
  final bool success;
  final String message;
  final PaymentModel data;
  final dynamic errors;

  const PaymentResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      success: json["success"],
      message: json["message"],
      data: PaymentModel.fromJson(json["data"]),
      errors: json["errors"],
    );
  }
}