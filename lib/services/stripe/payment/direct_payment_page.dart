import 'package:flutter/material.dart';
import 'package:skilltrain/main_app/common/buttons.dart';
import 'package:skilltrain/main_app/common/headings.dart';
import 'package:skilltrain/main_app/trainer/pages/instructor_view/pages/instructor_register_course.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../../utils/alert_dialogue.dart';
import 'package:intl/intl.dart';
import 'dart:math';

String sessionCode(int length) {
  const _randomeChars = "abcdefghijklmnopqrstuvwxyz0123456789";
  const _charsLength = _randomeChars.length;

  final rand = new Random();
  final codeUnits = new List.generate(length, (index) {
    final n = rand.nextInt(_charsLength);
    return _randomeChars.codeUnitAt(n);
  });
  return new String.fromCharCodes(codeUnits);
}

class DirectPaymentPage extends StatefulWidget {
  final String trainerUsername;
  final String title;
  final String genre;
  final String description;
  final String startTime;
  final String endTime;
  final int price;
  final String date;
  final String sessionId;
  final String traineeUsername;

  DirectPaymentPage({
    Key key,
    this.title,
    this.trainerUsername,
    this.date,
    this.description,
    this.startTime,
    this.endTime,
    this.genre,
    this.price,
    this.sessionId,
    this.traineeUsername,
  }) : super(key: key);

  @override
  _DirectPaymentPageState createState() => _DirectPaymentPageState();
}

class _DirectPaymentPageState extends State<DirectPaymentPage> {
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
      updateSession(widget.sessionId);
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

  Future<http.Response> updateSession(input) {
    return http.put(
      "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions/$input",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_username': widget.traineeUsername,
        'sessionCode': sessionCode(6),
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime newDate = DateTime.parse(widget.date);
    var format = new DateFormat("MMMEd");
    var dateString = format.format(newDate);

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color(0xFFFFFFFF),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
        ),
        body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 36, bottom: 64, top: 64),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    blackHeading(
                        title: "Book", underline: false, purple: false),
                    blackHeading(
                        title: "Session", underline: true, purple: true),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 36),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    color: Colors.purple,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.trainerUsername,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                          Text(dateString,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.genre,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            Text("¥" + widget.price.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 36.0),
                        child: Text(
                          description.length > 2
                              ? description
                              : "This trainer has not added any details about this session.",
                          maxLines: 3,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 36.0),
                        child: cyanButton(
                            text: "Pay Now",
                            function: () => {
                                  checkIfNativePayReady(),
                                }),
                      ),
                      // FlatButton(
                      //   onPressed: () {
                      //     checkIfNativePayReady();
                      //   },
                      //   child: Text(
                      //     'Amount to pay: ¥${amount.toString()}',
                      //     style: TextStyle(fontSize: 20.0),
                      //   ),
                      // ),
                      // Text(text),
                    ],
                  ),
                ),
              ),
            ])));
  }
}
