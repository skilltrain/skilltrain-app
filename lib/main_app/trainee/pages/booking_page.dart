import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:http/http.dart' as http;
import 'package:skilltrain/main_app/common/headings.dart';
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
  final String genre;
  final String bio;
  final int price;
  final int index;
  final DateTime stringDate = new DateTime.now().subtract(Duration(days: 1));
  BookingPage({this.index, this.trainerName, this.price, this.genre, this.bio});

  @override
  Widget build(BuildContext context) {
    final Future<List> sessionResults = fetchSessionResults(trainerName);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 36, bottom: 64, top: 64),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    blackHeading(title: trainerName + "'s", underline: false),
                    blackHeading(title: "Sessions", underline: true),
                  ],
                ),
              ),
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
                        print(snapshot.data[i]["trainer_username"]);
                        print(trainerName);
                        classArray.add(snapshot.data[i]);
                        classArray.sort((a, b) {
                          var adate = a["date"] + a["start_time"];
                          var bdate = b["date"] + b["start_time"];
                          return adate.compareTo(bdate);
                        });
                      }
                    }

                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.purple,
                        ),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 36, top: 18, bottom: 18),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Session Price - ¥" + price.toString(),
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 8),
                                  child: GestureDetector(
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          SlideLeftRoute(
                                              page: DirectPaymentPage(
                                                  trainerUsername:
                                                      trainerName)))
                                    },
                                    child: Card(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 7,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          bottom: 1,
                                                          // This can be the space you need betweeb text and underline
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border(
                                                                    bottom:
                                                                        BorderSide(
                                                          color:
                                                              Colors.cyanAccent,
                                                          width: 4.0,

                                                          // This would be the width of the underline
                                                        ))),
                                                        child: Text(
                                                          genre,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                        classArray[index][
                                                                        "description"]
                                                                    .length >
                                                                2
                                                            ? classArray[index]
                                                                ["description"]
                                                            : "This trainer has not added any details about this session.",
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[700],
                                                          fontSize: 14,
                                                        ))
                                                  ]),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                            classArray[index]
                                                                ["date"],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                            )),
                                                        Text(
                                                            classArray[index]
                                                                ["start_time"],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                            )),
                                                      ],
                                                    ),
                                                    Icon(Icons
                                                        .keyboard_arrow_right)
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: classArray.length,
                            )
                          ],
                        ));
                  } else if (snapshot.connectionState != ConnectionState.done) {
                    return Container(
                        height: MediaQuery.of(context).size.height - 87,
                        decoration:
                            new BoxDecoration(color: Colors.deepPurple[100]),
                        child: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Container(
                      height: MediaQuery.of(context).size.height - 87,
                      decoration:
                          new BoxDecoration(color: Colors.deepPurple[100]),
                      child: Center(child: CircularProgressIndicator()));
                },
              ),
            ],
          ),
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
Future<List> fetchSessionResults(input) async {
  try {
    AuthUser res = await Amplify.Auth.getCurrentUser();
    traineeName = res.username;
    print("Current Use Name = " + res.username);

    final response = await http.get(
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/$input/sessions');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load API params');
    }
  } on AuthError catch (e) {
    print(e);
  }
}
