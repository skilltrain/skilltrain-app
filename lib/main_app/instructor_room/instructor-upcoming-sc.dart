import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; //json file convert
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:intl/intl.dart';
import 'package:skilltrain/main_app/instructor_bio.dart';

import '../video_session/index_instructor.dart';

String trainerName = "";

class InstructorUpcomingSchedule extends StatefulWidget {
  final VoidCallback shouldLogOut;

  InstructorUpcomingSchedule({Key key, this.shouldLogOut}) : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

//define date format
DateFormat format = DateFormat('yyyy-MM-dd');

class SampleStart extends State<InstructorUpcomingSchedule> {
  Future<List> sessionResults;
  @override
  void initState() {
    super.initState();
    sessionResults = fetchSessionResults();
  }

  //calendar object
  DateTime _date = new DateTime.now(); //default date value
  String stringDate = format.format(new DateTime.now()
      .subtract(Duration(days: 1))); //default date value for card

  // Future<Null> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: _date,
  //       firstDate: new DateTime(2016),
  //       lastDate: new DateTime.now().add(new Duration(days: 360)));

  //   //Date format into String

  //   if (picked != null)
  //     setState(() => {
  //           _date = picked,
  //           stringDate = format.format(_date),
  //           print(_date),
  //           print(stringDate)
  //         });
  // }
//calendar object

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class registration',
      home: Scaffold(
        appBar: AppBar(
          title: Text('upcoming sessions'),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
              onPressed: () => Navigator.pop(context, false),
              icon: Icon(Icons.arrow_back)),
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
                        DateTime.parse(stringDate).isBefore(
                            DateTime.parse(snapshot.data[i]["date"]))) {
                      print(stringDate);
                      print(snapshot.data[i]["date"]);
                      classArray.add(snapshot.data[i]);
                    } else
                      print("something went wrong with fetched data");
                  }

//calendar object
                  return Container(
                      height: 678,
                      width: double.infinity,
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        children: <Widget>[
                          Center(child: Text("last update:" + "$_date")),
                          // new RaisedButton(
                          //   onPressed: () => _selectDate(context),
                          //   child: new Text('日付選択'),
                          // ),
                          SizedBox(
                              height: 514,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
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
                                                      CrossAxisAlignment.center,
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
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          Text(
                                                              classArray[index][
                                                                      "start_time"] +
                                                                  " - " +
                                                                  classArray[
                                                                          index]
                                                                      [
                                                                      "end_time"],
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              )),
                                                          Text(
                                                            "With " +
                                                                classArray[
                                                                        index][
                                                                    "user_username"],
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ]),
                                                    new Spacer(),
                                                    Column(
                                                      children: <Widget>[
                                                        Text(
                                                          "Session Code",
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                        Text(
                                                            classArray[index]
                                                                ["sessionCode"],
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                            ))
                                                      ],
                                                    ),
                                                    new Spacer(),
                                                    ButtonTheme(
                                                      minWidth: 30,
                                                      child: RaisedButton(
                                                          child: Icon(Icons
                                                              .video_call_rounded),
                                                          onPressed: () => {
                                                                Navigator.push(
                                                                    context,
                                                                    SlideLeftRoute(
                                                                        page:
                                                                            IndexPageForInstructor()))
                                                              }),
                                                    ),
                                                  ]),
                                            ],
                                          )));
                                },
                                itemCount: classArray.length,
                              )),
                        ],
                      ));

//calendar object
                } else if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: missing_return
Future<List> fetchSessionResults() async {
  try {
    AuthUser res = await Amplify.Auth.getCurrentUser();
    trainerName = res.username;
    print("Current User Name = " + res.username);

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
