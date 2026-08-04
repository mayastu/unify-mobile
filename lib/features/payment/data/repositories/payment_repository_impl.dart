import '../data_source/payment_remote_datasource.dart';
import '../models/payment_model.dart';
import '../models/payment_request_model.dart';
import 'payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remote;

  PaymentRepositoryImpl(this.remote);

  @override
  Future<List<PaymentModel>> getPayments() {
    return remote.getPayments();
  }

  @override
  Future<PaymentModel> getPayment(int id) {
    return remote.getPayment(id);
  }

  @override
  Future<PaymentModel> createPayment({
    required PaymentRequestModel request,
  }) {
    return remote.createPayment(request: request);
  }
}