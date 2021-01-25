import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; //json file convert
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:skilltrain/main_app/common/headings.dart';

String trainerName = "";
String userName = "";
String year = "";
String month = "";
String day = "";
String startTime = "";
String endTime = "";
bool status = false;
bool complete = false;
String description = "";

String _selectedYear = "Year";
String _selectedMonth = "Month";
String _selectedDate = "Day";
String _selectedStartTime = "Time";

class InstructorRegisterCourse extends StatefulWidget {
  final VoidCallback shouldLogOut;

  InstructorRegisterCourse({Key key, this.shouldLogOut}) : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

class SampleStart extends State<InstructorRegisterCourse> {
  Future<List> futureApiResults;
  Future<ApiResults> resFromPostReq;
  final _timeKey = GlobalKey<FormState>();
  final _dayKey = GlobalKey<FormState>();
  final _monthKey = GlobalKey<FormState>();
  final _yearKey = GlobalKey<FormState>();

  // ignore: unused_field
  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();
    _selectedYear = "Year";
    _selectedMonth = "Month";
    _selectedDate = "Day";
    _selectedStartTime = "Time";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Class Registration',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme:
                  IconThemeData(color: Colors.black), //change your color here
              title: Text('Booked sessions'),
              centerTitle: true,
              automaticallyImplyLeading: true,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: Icon(Icons.arrow_back)),
            ),
            body: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.all(36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            blackHeading(
                                title: "Register a",
                                underline: false,
                                purple: false),
                            blackHeading(
                                title: "Session",
                                underline: true,
                                purple: false)
                          ],
                        )),
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                      ),
                      color: Colors.purple,
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: Colors.white, size: 18),
                              sectionTitle(title: " Date"),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  child: Form(
                                    key: _yearKey,
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      iconEnabledColor: Colors.white,
                                      isExpanded: true,
                                      hint: Text(_selectedYear,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      items: <String>[
                                        '2021',
                                        '2022',
                                        '2023',
                                        '2024',
                                        '2025'
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Center(
                                            child: new Text(value,
                                                textAlign: TextAlign.center),
                                          ),
                                        );
                                      }).toList(),
                                      validator: (value) => value == null
                                          ? 'Please select a year'
                                          : null,
                                      onChanged: (value) {
                                        _selectedYear = value;
                                        year = value;
                                        print("year is" + value);
                                        setState(() {
                                          _selectedYear = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  // width: MediaQuery.of(context)
                                  //         .size
                                  //         .width *
                                  //     0.24,
                                  child: Container(
                                    child: Form(
                                      key: _monthKey,
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                            border: InputBorder.none),
                                        iconEnabledColor: Colors.white,
                                        hint: Text(_selectedMonth,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        isExpanded: true,
                                        items: <String>[
                                          '01',
                                          '02',
                                          '03',
                                          '04',
                                          '05',
                                          '06',
                                          '07',
                                          '08',
                                          '09',
                                          '10',
                                          '11',
                                          '12'
                                        ].map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: Center(
                                              child: new Text(value,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ),
                                          );
                                        }).toList(),
                                        validator: (value) => value == null
                                            ? 'Please select a month'
                                            : null,
                                        onChanged: (value) {
                                          month = value;
                                          print("month is" + value);
                                          setState(() {
                                            _selectedMonth = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                    child: Form(
                                  key: _dayKey,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    iconEnabledColor: Colors.white,
                                    isExpanded: true,
                                    hint: Text(_selectedDate,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    items: <String>[
                                      '01',
                                      '02',
                                      '03',
                                      '04',
                                      '05',
                                      '06',
                                      '07',
                                      '08',
                                      '09',
                                      '10',
                                      '11',
                                      '12',
                                      '13',
                                      '14',
                                      '15',
                                      '16',
                                      '17',
                                      '18',
                                      '19',
                                      '20',
                                      '21',
                                      '22',
                                      '23',
                                      '24',
                                      '25',
                                      '26',
                                      '27',
                                      '28',
                                      '29',
                                      '30',
                                      '31',
                                    ].map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: Center(
                                          child: new Text(value,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                        ),
                                      );
                                    }).toList(),
                                    validator: (value) => value == null
                                        ? 'Please select a day'
                                        : null,
                                    onChanged: (value) {
                                      day = value;
                                      print("month is" + day);
                                      setState(() {
                                        _selectedDate = value;
                                      });
                                    },
                                  ),
                                )),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  child: Form(
                                    key: _timeKey,
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      iconEnabledColor: Colors.white,
                                      isExpanded: true,
                                      hint: Text(_selectedStartTime,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      items: <String>[
                                        '09:00',
                                        '10:00',
                                        '11:00',
                                        '12:00',
                                        '13:00',
                                        '14:00',
                                        '15:00',
                                        '16:00',
                                        '17:00',
                                        '18:00',
                                        '19:00',
                                        '20:00',
                                        '21:00',
                                        '22:00',
                                        '23:00'
                                      ].map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: Center(
                                            child: new Text(value,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                          ),
                                        );
                                      }).toList(),
                                      validator: (value) => value == null
                                          ? 'Please select a time'
                                          : null,
                                      onChanged: (value) {
                                        startTime = value;
                                        endTime =
                                            startTime.substring(0, 3) + "50";
                                        print("start time is" + startTime);
                                        print("end time  is" + endTime);
                                        setState(() {
                                          startTime = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Container(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: Colors.white, size: 18),
                                  sectionTitle(title: " Session Description"),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.purple[500], width: 1),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                                controller:
                                    TextEditingController(text: description),
                                decoration: InputDecoration(),
                                maxLines: 8,
                                minLines: 8,
                                onChanged: (text) => description = text),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                primary: Colors.cyanAccent, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              onPressed: () async {
                                if (_dayKey.currentState.validate() &&
                                    _yearKey.currentState.validate() &&
                                    _monthKey.currentState.validate() &&
                                    _timeKey.currentState.validate()) {
                                  final dynamic result =
                                      await postData(context);
                                  return result;
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.fitness_center),
                                  Text(" Register Session",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              )),
                        ],
                      ),
                    )),
              ],
            )));
  }
}

Future<Map> postData(BuildContext context) async {
  AuthUser res = await Amplify.Auth.getCurrentUser();
  userName = res.username;

  var url =
      "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions";

  var request = {
    'trainer_username': userName,
    'user_username': "",
    'id': year + "-" + month + "-" + day + startTime + userName,
    'sessionCode': year + "-" + month + "-" + day + startTime + userName,
    'date': year + "-" + month + "-" + day,
    'start_time': startTime,
    'end_time': endTime,
    'status': status,
    'complete': complete,
    "description": description
  };

  print(json.encode(request));

  final response = await http.post(url,
      body: json.encode(request),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    print("new calendar record POST request successful");

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("New course has been registered"),
          children: <Widget>[
            // コンテンツ領域
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: Text(""),
            ),
          ],
        );
      },
    );

    Navigator.pop(context);

    return json.decode(response.body);
  } else {
    print(response.statusCode);
    throw Exception('Failed');
  }
}

class ApiResults {
  final String message;
  ApiResults({
    this.message,
  });
  factory ApiResults.fromJson(Map<String, dynamic> json) {
    return ApiResults(
      message: json['message'],
    );
  }
}
