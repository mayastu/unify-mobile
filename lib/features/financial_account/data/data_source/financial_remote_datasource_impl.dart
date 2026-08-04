import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/financial_account_model.dart';
import '../models/hour_purchase_model.dart';
import 'financial_remote_datasource.dart';

class FinancialRemoteDataSourceImpl implements FinancialRemoteDataSource {
  final ApiConsumer api;

  FinancialRemoteDataSourceImpl(this.api);

  @override
  Future<FinancialAccountModel> getFinancialAccount(int studentId) async {
    final response = await api.get(
      "${EndPoints.financialAccount}/$studentId",
    );

    return FinancialAccountModel.fromJson(
      response["data"],
    );
  }

  @override
  Future<List<HourPurchaseModel>> getHourPurchases() async {
    final response = await api.get(
      EndPoints.hourPurchases,
    );

    final List data = response["data"];

    return data.map((e) => HourPurchaseModel.fromJson(e)).toList();
  }

  @override
  Future<void> purchaseCreditHours({
    required int studentId,
    required int creditHours,
  }) async {
    await api.post(
      EndPoints.hourPurchases,
      data: {
        "student_id": studentId,
        "credit_hours": creditHours,
      },
    );
  }
}
