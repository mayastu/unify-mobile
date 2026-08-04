class PaymentRequestModel {
  final int studentId;
  final double amount;
  final String referenceNumber;
  final String paymentDate;

  const PaymentRequestModel({
    required this.studentId,
    required this.amount,
    required this.referenceNumber,
    required this.paymentDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "student_id": studentId,
      "amount": amount,
      "reference_number": referenceNumber,
      "payment_date": paymentDate,
    };
  }
}