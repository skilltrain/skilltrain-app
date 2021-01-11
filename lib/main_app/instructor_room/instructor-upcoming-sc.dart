import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; //json file convert

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:intl/intl.dart';

String UserName = "";

const sampleData = [
  { 
    "instructor":"Yuta",
    "availability": [
      {
        "date": "2021-01-11",
        "startTime": "09:00",
        "endTime": "09:50",
        "instructorName": "Yuta",
        "studentName": "Hide",
        "classRoom":"hogehoge",
        "isClass":true
      },
      {
        "date": "2021-01-11",
        "startTime": "10:00",
        "endTime": "10:50",
        "instructorName": "Yuta",
        "studentName": "Elliot",
        "classRoom":"hogehoge"
        
      },
      {
        "date": "2021-01-12",
        "startTime": "09:00",
        "endTime": "10:50",
        "instructorName": "Damina",
        "studentName": "Hide",
        "classRoom":"icecream"
      },

    ]
  }
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
  DateTime _date = new DateTime.now();//default date value
  String StringDate = format.format(new DateTime.now());//default date value for card
 
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360))
    );


  //Date format into String

    if(picked != null) setState(() => {
      _date = picked,
      StringDate = format.format(_date),
      print(_date),
      print(StringDate)
      });
      
  }
//calendar object

class InstructorUpcomingSchedule extends StatelessWidget {
  int index;
  InstructorUpcomingSchedule({this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("upcoming schedule"),
        ),
      ),
    );
  }
}
