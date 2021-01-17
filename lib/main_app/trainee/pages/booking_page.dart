import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:http/http.dart' as http;
import 'package:skilltrain/main_app/trainer/pages/instructor_view/pages/instructor_register_course.dart';
import 'dart:convert';
import '../../../services/stripe/payment/direct_payment_page.dart';
import '../../../utils/sliders.dart';
import 'dart:math';

String traineeName = "";

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

class BookingPage extends StatelessWidget {
  final String trainerName;
  final int price;
  final int index;
  final Future<List> sessionResults = fetchSessionResults();
  BookingPage({this.index, this.trainerName, this.price});

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
                    print(trainerName);
                    print(traineeName);
                    print(price);
                    print(sessionCode(6));
                    Navigator.push(
                        context,
                        SlideLeftRoute(
                            page: MyHomePage(trainerUsername: trainerName)));
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
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/' +
            trainerName +
            '/sessions');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load API params');
    }
  } on AuthError catch (e) {
    print(e);
  }
}
