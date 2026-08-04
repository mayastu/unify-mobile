import '../../data/models/payment_model.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<PaymentModel> payments;

  PaymentLoaded(this.payments);
}

class PaymentSuccess extends PaymentState {
  final PaymentModel payment;

  PaymentSuccess(this.payment);
}

class PaymentDetailsLoaded extends PaymentState {
  final PaymentModel payment;

  PaymentDetailsLoaded(this.payment);
}

class PaymentFailure extends PaymentState {
  final String message;

  PaymentFailure(this.message);
}