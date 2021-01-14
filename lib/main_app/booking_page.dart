import 'package:flutter/material.dart';
import '../services/stripe/payment/direct_payment_page.dart';
import './home_page.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String traineeName = "";

class Booking extends StatelessWidget {
  final String trainerName;
  final int price;
  final int index;
  final Future<List> sessionResults = fetchSessionResults();
  Booking({this.index, this.trainerName, this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("booking"),
        ),
        body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: Row(children: <Widget>[
                Text("sample schedule",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    )),
                new Spacer(),
                RaisedButton(
                  onPressed: () {
                    // Insert PUT method function to update user_username/sessionCode info in sessions table
                    print(1);
                    print(trainerName);
                    print(traineeName);
                    print(price);
                    print(sessionResults);
                    Navigator.push(context, SlideLeftRoute(page: MyHomePage()));
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.pink[300],
                          Colors.purple[500],
                          Colors.purple[700],
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: const Text('booking now'),
                  ),
                ),
              ]));
            },
            itemCount: 10));
  }
}

// ignore: missing_return
Future<List> fetchSessionResults() async {
  try {
    AuthUser res = await Amplify.Auth.getCurrentUser();
    traineeName = res.username;
    print("Current Use Name = " + res.username);

    final response = await http.get(
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load API params');
    }
  } on AuthError catch (e) {
    print(e);
  }
}
