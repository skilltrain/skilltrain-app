import 'package:flutter/material.dart';
import './payment_signup_service.dart';
import '../../../utils/sliders.dart';
import '../../../main_app/trainer/pages/payment_signup.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class PaymentSignUp extends StatefulWidget {
  final cognitoUser;

  const PaymentSignUp({Key key, this.cognitoUser}) : super(key: key);

  @override
  _PaymentSignUpState createState() => _PaymentSignUpState();
}

class _PaymentSignUpState extends State<PaymentSignUp> {
  PaymentSignUpService _paymentSignUpService;
  Stream paymentState;
  List<CognitoUserAttribute> attributes;

  @override
  void initState() {
    super.initState();
    _paymentSignUpService = new PaymentSignUpService();
    paymentState = _paymentSignUpService.paymentSignUpController.stream;
    checkIfSigned();
  }

  void checkIfSigned() async {
    bool attributeExists = false;
    attributes = await widget.cognitoUser.getUserAttributes();
    attributes.forEach((attribute) {
      if (attribute.getName() == 'custom:paymentSignedUp') {
        attributeExists = true;
        if (attribute.getValue() == 'true') {
          _paymentSignUpService.showSignedPage();
        } else {
          _paymentSignUpService.showUnsignedPage();
        }
      }
    });
    // Fail safe if the attribute doesn't exist
    // Old accounts were not generated with this attribute, will later be
    // added in after signing up
    if (!attributeExists) {
      _paymentSignUpService.showUnsignedPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PaymentSignUpState>(
        stream: paymentState,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data.paymentSignUpFlowStatus ==
                PaymentSignUpFlowStatus.unsigned)
              return ListTile(
                title: Text('Payment signup'),
                onTap: () {
                  Navigator.push(
                    context,
                    SlideLeftRoute(
                        page: PaymentSignup(
                            userAttributes: attributes,
                            cognitoUser: widget.cognitoUser,
                            signUpComplete:
                                _paymentSignUpService.showSignedPage)),
                  );
                },
              );
            else {
              return ListTile(
                title: Text('Complete'),
              );
            }
          } else {
            return Text('Error');
          }
        });
  }
}
