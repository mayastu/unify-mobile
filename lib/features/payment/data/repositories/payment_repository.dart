import '../models/payment_model.dart';
import '../models/payment_request_model.dart';

abstract class PaymentRepository {
  Future<List<PaymentModel>> getPayments();

  Future<PaymentModel> getPayment(int id);

  Future<PaymentModel> createPayment({
    required PaymentRequestModel request,
  });
}