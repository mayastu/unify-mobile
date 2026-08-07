import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/repositories/financial_repository.dart';
import 'financial_state.dart';

class FinancialCubit extends Cubit<FinancialState> {
  final FinancialRepository repository;

  FinancialCubit(this.repository) : super(FinancialInitial());

  Future<void> getFinancialAccount() async {
    emit(FinancialLoading());

    try {
      final studentId = await SecureStorage.getStudentId();

      final account =
      await repository.getFinancialAccount(studentId);

      final purchases =
      await repository.getHourPurchases();

      emit(
        FinancialSuccess(
          account: account,
          purchases: purchases,
        ),
      );
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);

      emit(FinancialFailure(e.toString()));
    }
  }

  Future<void> purchaseCreditHours(
      int creditHours,
      ) async {
    emit(PurchaseLoading());

    try {
      final studentId =
      await SecureStorage.getStudentId();

      await repository.purchaseCreditHours(
        studentId: studentId,
        creditHours: creditHours,
      );

      emit(PurchaseSuccess());

      await getFinancialAccount();
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);

      emit(PurchaseFailure(e.toString()));
    }
  }
}