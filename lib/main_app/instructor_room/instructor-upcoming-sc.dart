import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; //json file convert
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:intl/intl.dart';
import 'package:skilltrain/main_app/instructor_bio.dart';

import '../video_session/index_instructor.dart';

String userName = "";

const sampleData = [
  {
    "trainer_username": "hide_trainer",
    "user_username": "Yuta",
    "date": "2021-01-11",
    "sessionCode": "test",
    "complete": "true",
    "status": "true",
    "start_time": "09:00",
    "end_time": "09:50",
  },
  {
    "trainer_username": "hide_trainer",
    "user_username": "Damian",
    "date": "2021-01-11",
    "sessionCode": "test",
    "complete": "true",
    "status": "true",
    "start_time": "10:00",
    "end_time": "10:50",
  },
  {
    "trainer_username": "athelian",
    "user_username": "Eliot",
    "date": "2021-01-12",
    "sessionCode": "test",
    "complete": "true",
    "status": "true",
    "start_time": "09:00",
    "end_time": "09:50",
  },
  {
    "trainer_username": "damian",
    "user_username": "John",
    "date": "2021-01-12",
    "sessionCode": "test",
    "complete": "true",
    "status": "true",
    "start_time": "10:00",
    "end_time": "10:50",
  },
];

class InstructorUpcomingSchedule extends StatefulWidget {
  final VoidCallback shouldLogOut;

  InstructorUpcomingSchedule({Key key, this.shouldLogOut}) : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

//define date format
DateFormat format = DateFormat('yyyy-MM-dd');

class SampleStart extends State<InstructorUpcomingSchedule> {
  Future<List> futureApiResults;
  @override
  void initState() {
    super.initState();
    futureApiResults = fetchApiResults();
  }

//calendar object
  DateTime _date = new DateTime.now(); //default date value
  String stringDate =
      format.format(new DateTime.now()); //default date value for card

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360)));

    //Date format into String

    if (picked != null)
      setState(() => {
            _date = picked,
            stringDate = format.format(_date),
            print(_date),
            print(stringDate)
          });
  }
//calendar object

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class registration',
      home: Scaffold(
        appBar: AppBar(
          title: Text('skillTrain'),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
              onPressed: () => Navigator.pop(context, false),
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: Column(
          children: <Widget>[
            FutureBuilder<List>(
              future: futureApiResults,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List classArray = [];
                  for (int i = 0; i < sampleData.length; i++) {
                    if (sampleData[i]["trainer_username"] == userName) {
                      classArray.add(sampleData[i]);
                      // print(ClassArray);
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
                          Center(child: Text("$_date")),
                          new RaisedButton(
                            onPressed: () => _selectDate(context),
                            child: new Text('日付選択'),
                          ),
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
                                                            stringDate,
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
                                                                "user_username"],
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ]),
                                                    new Spacer(),
                                                    Text("USD /h ",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                        )),
                                                    new Spacer(),
                                                    RaisedButton(
                                                        child: Icon(Icons
                                                            .video_call_rounded),
                                                        onPressed: () => {
                                                              Navigator.push(
                                                                  context,
                                                                  SlideLeftRoute(
                                                                      page:
                                                                          IndexPageForInstructor()))
                                                            }),
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
Future<List> fetchApiResults() async {
  try {
    AuthUser res = await Amplify.Auth.getCurrentUser();
    userName = res.username;
    print("Current User Name = " + res.username);

    final response = await http.get(
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load API params');
    }
  } on AuthError catch (e) {
    print(e);
  }
}
