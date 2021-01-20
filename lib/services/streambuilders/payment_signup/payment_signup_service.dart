import 'dart:async';

// Specify session flow
enum PaymentSignUpFlowStatus { unsigned, signed }

class PaymentSignUpState {
  final PaymentSignUpFlowStatus paymentSignUpFlowStatus;
  PaymentSignUpState({this.paymentSignUpFlowStatus});
}

class PaymentSignUpService {
  final paymentSignUpController = StreamController<PaymentSignUpState>();

  void showUnsignedPage() {
    final state = PaymentSignUpState(
        paymentSignUpFlowStatus: PaymentSignUpFlowStatus.unsigned);
    paymentSignUpController.add(state);
  }

  void showSignedPage() {
    final state = PaymentSignUpState(
        paymentSignUpFlowStatus: PaymentSignUpFlowStatus.signed);
    paymentSignUpController.add(state);
  }
}
