import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../../utils/alert_dialogue.dart';

class MyHomePage extends StatefulWidget {
  final String trainerUsername;
  final String title;

  MyHomePage({Key key, this.title, this.trainerUsername}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = 'Click the button to start the payment';
  double totalCost = 1000;
  double tip = 0.0;
  double tax = 0.0;
  double taxPercent = 0.0;
  int amount = 1000;
  bool showSpinner = false;
  String url =
      'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/stripe';
  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            'pk_test_51HyVhmGoiP0exFcuAZepXKFpVGkwfh1ndIeGP8YjHSrMcEheFAs3QHma8AwVuSOZYz0DW4JyBzYlzXt2FriESDC300eRgPaPyv', // add you key as per Stripe dashboard
        merchantId: 'Test',
        androidPayMode: 'test',
      ),
    );
  }

  void checkIfNativePayReady() async {
    print('started to check if native pay ready');
    bool deviceSupportNativePay = await StripePayment.deviceSupportsNativePay();
    bool isNativeReady = await StripePayment.canMakeNativePayPayments(
        ['american_express', 'visa', 'maestro', 'master_card']);
    deviceSupportNativePay && isNativeReady
        ? createPaymentMethodNative()
        : createPaymentMethod();
  }

  Future<void> createPaymentMethodNative() async {
    print('started NATIVE payment...');
    StripePayment.setStripeAccount(null);
    List<ApplePayItem> items = [];
    items.add(ApplePayItem(
      label: 'Demo Order',
      amount: totalCost.toString(),
    ));
    if (tip != 0.0)
      items.add(ApplePayItem(
        label: 'Tip',
        amount: tip.toString(),
      ));
    if (taxPercent != 0.0) {
      tax = (totalCost * taxPercent).ceil() / 100;
      items.add(ApplePayItem(
        label: 'Tax',
        amount: tax.toString(),
      ));
    }
    items.add(ApplePayItem(
      label: 'Vendor A',
      amount: (totalCost + tip + tax).toString(),
    ));
    amount = (totalCost + tip + tax).toInt();
    print('amount in yen which will be charged = $amount');
    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();
    Token token = await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: (totalCost + tax + tip).toStringAsFixed(2),
        currencyCode: 'JPY',
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'JP',
        currencyCode: 'JPY',
        items: items,
      ),
    );
    paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: CreditCard(
          token: token.tokenId,
        ),
      ),
    );
    paymentMethod != null
        ? processPaymentAsDirectCharge(paymentMethod)
        : showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialogue(
                title: 'Error',
                content:
                    'It is not possible to pay with this card. Please try again with a different card',
                buttonText: 'CLOSE'));
  }

  Future<void> processPaymentAsDirectCharge(PaymentMethod paymentMethod) async {
    setState(() {
      showSpinner = true;
    });
    print(widget.trainerUsername);
    //step 2: request to create PaymentIntent, attempt to confirm the payment & return PaymentIntent
    final http.Response idResponse =
        await http.get('$url?username=${widget.trainerUsername}');
    final connAccID = jsonDecode(idResponse.body);
    print(connAccID);
    final http.Response response = await http.post(
        '$url?amount=$amount&currency=JPY&paym=${paymentMethod.id}&connAccID=$connAccID');
    print('Now i decode');
    if (response.statusCode == 200) {
      final paymentIntentX = jsonDecode(response.body);
      final status = paymentIntentX['paymentIntent']['status'];
      final strAccount = paymentIntentX['stripeAccount'];
      //step 3: check if payment was succesfully confirmed
      if (status == 'succeeded') {
        //payment was confirmed by the server without need for futher authentification
        StripePayment.completeNativePayRequest();
        setState(() {
          text =
              'Payment completed. ¥${paymentIntentX['paymentIntent']['amount'].toString()} succesfully charged';
          showSpinner = false;
        });
        await new Future.delayed(const Duration(seconds: 3));
        Navigator.pop(context);
      } else {
        //step 4: there is a need to authenticate
        StripePayment.setStripeAccount(strAccount);
        await StripePayment.confirmPaymentIntent(PaymentIntent(
                paymentMethodId: paymentIntentX['paymentIntent']
                    ['payment_method'],
                clientSecret: paymentIntentX['paymentIntent']['client_secret']))
            .then(
          (PaymentIntentResult paymentIntentResult) async {
            //This code will be executed if the authentication is successful
            //step 5: request the server to confirm the payment with
            final statusFinal = paymentIntentResult.status;
            if (statusFinal == 'succeeded') {
              StripePayment.completeNativePayRequest();
              setState(() {
                showSpinner = false;
              });
            } else if (statusFinal == 'processing') {
              StripePayment.cancelNativePayRequest();
              setState(() {
                showSpinner = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialogue(
                      title: 'Warning',
                      content:
                          'The payment is still in \'processing\' state. This is unusual. Please contact us',
                      buttonText: 'CLOSE'));
            } else {
              StripePayment.cancelNativePayRequest();
              setState(() {
                showSpinner = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialogue(
                      title: 'Error',
                      content:
                          'There was an error to confirm the payment. Details: $statusFinal',
                      buttonText: 'CLOSE'));
            }
          },
          //If Authentication fails, a PlatformException will be raised which can be handled here
        ).catchError((e) {
          //case B1
          StripePayment.cancelNativePayRequest();
          setState(() {
            showSpinner = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialogue(
                  title: 'Error',
                  content:
                      'There was an error to confirm the payment. Please try again with another card',
                  buttonText: 'CLOSE'));
        });
      }
    } else {
      //case A
      StripePayment.cancelNativePayRequest();
      setState(() {
        showSpinner = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialogue(
              title: 'Error',
              content:
                  'There was an error in creating the payment. Please try again with another card',
              buttonText: 'CLOSE'));
    }
  }

  Future<void> createPaymentMethod() async {
    StripePayment.setStripeAccount(null);
    tax = ((totalCost * taxPercent) * 100).ceil() / 100;
    amount = (totalCost + tip + tax).toInt();
    print('amount in yen which will be charged = $amount');
    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();
    paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    ).then((PaymentMethod paymentMethod) {
      return paymentMethod;
    }).catchError((e) {
      print('Error Card: ${e.toString()}');
    });
    paymentMethod != null
        ? processPaymentAsDirectCharge(paymentMethod)
        : showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialogue(
                title: 'Error',
                content:
                    'It is not possible to pay with this card. Please try again with a different card',
                buttonText: 'CLOSE'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Payment'),
        ),
        body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      checkIfNativePayReady();
                    },
                    child: Text(
                      'Amount to pay: ¥${amount.toString()}',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Text(text),
                ]))));
  }
}
