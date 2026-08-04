import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/payment_request_model.dart';
import '../../data/repositories/payment_repository.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository repository;

  PaymentCubit(this.repository) : super(PaymentInitial());

  List payments = [];

  ///=========================
  /// Get All Payments
  ///=========================

  Future<void> getPayments() async {
    emit(PaymentLoading());

    try {
      final response = await repository.getPayments();

      payments = response;

      emit(PaymentLoaded(response));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  ///=========================
  /// Create Payment
  ///=========================

  Future<void> createPayment({
    required int studentId,
    required double amount,
    required String referenceNumber,
    required String paymentDate,
  }) async {
    emit(PaymentLoading());

    try {
      final payment = await repository.createPayment(
        request: PaymentRequestModel(
          studentId: studentId,
          amount: amount,
          referenceNumber: referenceNumber,
          paymentDate: paymentDate,
        ),
      );

      emit(PaymentSuccess(payment));

      /// بعد نجاح العملية حدّث القائمة مباشرة
      await getPayments();
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  ///=========================
  /// Get Payment Details
  ///=========================

  Future<void> getPayment(int id) async {
    emit(PaymentLoading());

    try {
      final payment = await repository.getPayment(id);

      emit(PaymentDetailsLoaded(payment));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}