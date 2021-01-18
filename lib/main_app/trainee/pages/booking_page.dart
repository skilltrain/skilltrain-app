import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:http/http.dart' as http;
import 'package:skilltrain/main_app/trainee/pages/booking_status.dart';
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
  final DateTime stringDate = new DateTime.now().subtract(Duration(days: 1));
  BookingPage({this.index, this.trainerName, this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("booking"),
        ),
        body: Column(
          children: <Widget>[
            FutureBuilder<List>(
              future: sessionResults,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List classArray = [];
                  for (int i = 0; i < snapshot.data.length; i++) {
                    if (snapshot.data[i]["trainer_username"] == trainerName &&
                        snapshot.data[i]["complete"] == false &&
                        snapshot.data[i]["status"] == false &&
                        snapshot.data[i]["user_username"] == "" &&
                        stringDate.isBefore(
                            DateTime.parse(snapshot.data[i]["date"]))) {
                      print(snapshot.data[i]["date"]);
                      classArray.add(snapshot.data[i]);
                      classArray.sort((a, b) {
                        var adate = a["date"];
                        var bdate = b["date"];
                        return adate.compareTo(bdate);
                      });
                      classArray.sort((a, b) {
                        var adate = a["start_time"];
                        var bdate = b["start_time"];
                        return adate.compareTo(bdate);
                      });
                    } else
                      print("something went wrong with fetched data");
                  }

//calendar object
                  return Container(
                      height: 678,
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: SizedBox(
                                height: 620,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                        child: GestureDetector(
                                            //画面遷移
                                            onTap: () => {},
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              classArray[index]
                                                                  ["date"],
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                            Text(
                                                                classArray[index]
                                                                        [
                                                                        "start_time"] +
                                                                    " - " +
                                                                    classArray[
                                                                            index]
                                                                        [
                                                                        "end_time"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                )),
                                                          ]),
                                                      new Spacer(),
                                                      ButtonTheme(
                                                        minWidth: 30,
                                                        child: RaisedButton(
                                                          onPressed: () {
                                                            // Insert PUT method function to update user_username/sessionCode info in sessions table
                                                            print(traineeName);
                                                            print(trainerName);
                                                            print(price);
                                                            print(classArray[
                                                                index]["id"]);
                                                            print(
                                                                sessionCode(6));
                                                            updateSession(
                                                                classArray[
                                                                        index]
                                                                    ["id"]);
                                                            Navigator.push(
                                                                context,
                                                                SlideLeftRoute(
                                                                    page: MyHomePage(
                                                                        trainerUsername:
                                                                            trainerName)));
                                                          },
                                                          textColor:
                                                              Colors.white,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: <Color>[
                                                                  Colors.pink[
                                                                      300],
                                                                  Colors.purple[
                                                                      500],
                                                                  Colors.purple[
                                                                      700],
                                                                ],
                                                              ),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            child: const Text(
                                                                'book now'),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              ],
                                            )));
                                  },
                                  itemCount: classArray.length,
                                )),
                          )
                        ],
                      ));
                } else if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ));
  }
}

Future<http.Response> updateSession(input) {
  return http.put(
    "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions/$input",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user_username': traineeName,
      'sessionCode': sessionCode(6),
    }),
  );
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
