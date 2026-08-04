import '../models/financial_account_model.dart';
import '../models/hour_purchase_model.dart';

abstract class FinancialRepository {
  Future<FinancialAccountModel> getFinancialAccount(int studentId);

  Future<List<HourPurchaseModel>> getHourPurchases();

  Future<void> purchaseCreditHours({
    required int studentId,
    required int creditHours,
  });
}