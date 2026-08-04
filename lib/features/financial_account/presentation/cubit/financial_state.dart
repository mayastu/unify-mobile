import '../../data/models/financial_account_model.dart';
import '../../data/models/hour_purchase_model.dart';

abstract class FinancialState {}

class FinancialInitial extends FinancialState {}

class FinancialLoading extends FinancialState {}

class FinancialSuccess extends FinancialState {
  final FinancialAccountModel account;
  final List<HourPurchaseModel> purchases;

  FinancialSuccess({
    required this.account,
    required this.purchases,
  });
}

class FinancialFailure extends FinancialState {
  final String message;

  FinancialFailure(this.message);
}

class PurchaseLoading extends FinancialState {}

class PurchaseSuccess extends FinancialState {}

class PurchaseFailure extends FinancialState {
  final String message;

  PurchaseFailure(this.message);
}