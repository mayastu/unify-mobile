import '../data_source/financial_remote_datasource.dart';
import '../models/financial_account_model.dart';
import '../models/hour_purchase_model.dart';
import 'financial_repository.dart';

class FinancialRepositoryImpl implements FinancialRepository {
  final FinancialRemoteDataSource remoteDataSource;

  FinancialRepositoryImpl(this.remoteDataSource);

  @override
  Future<FinancialAccountModel> getFinancialAccount(int studentId) {
    return remoteDataSource.getFinancialAccount(studentId);
  }

  @override
  Future<List<HourPurchaseModel>> getHourPurchases() async {
    return remoteDataSource.getHourPurchases();
  }

  @override
  Future<void> purchaseCreditHours(
      {required int studentId, required int creditHours}) {
    return remoteDataSource.purchaseCreditHours(
        studentId: studentId, creditHours: creditHours);
  }
}
