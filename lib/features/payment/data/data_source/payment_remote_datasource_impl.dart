import 'package:unify/core/api/api_consumer.dart';
import 'package:unify/core/api/end_points.dart';
import 'package:unify/features/payment/data/data_source/payment_remote_datasource.dart';
import 'package:unify/features/payment/data/models/payment_request_model.dart';
import '../models/payment_model.dart';

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiConsumer api;

  PaymentRemoteDataSourceImpl(this.api);

  @override
  Future<List<PaymentModel>> getPayments() async {
    final response = await api.get(
      EndPoints.payments,
    );

    return (response["data"] as List)
        .map((e) => PaymentModel.fromJson(e))
        .toList();
  }

  @override
  Future<PaymentModel> getPayment(int id) async {
    final response = await api.get(
      "${EndPoints.payments}/$id",
    );

    return PaymentModel.fromJson(response["data"]);
  }

  @override
  Future<PaymentModel> createPayment({
    required PaymentRequestModel request,
  }) async {
    final response = await api.post(
      EndPoints.payments,
      data: request.toJson(),
    );

    return PaymentModel.fromJson(response["data"]);
  }
}