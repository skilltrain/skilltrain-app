import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; //json file convert

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:intl/intl.dart';

String userName = "";

const sampleData = [
  {
    "instructor": "Yuta",
    "availability": [
      {
        "date": "2021-01-11",
        "startTime": "09:00",
        "endTime": "09:50",
        "instructorName": "Yuta",
        "studentName": "Hide",
        "classRoom": "hogehoge",
        "isClass": true
      },
      {
        "date": "2021-01-11",
        "startTime": "10:00",
        "endTime": "10:50",
        "instructorName": "Yuta",
        "studentName": "Elliot",
        "classRoom": "hogehoge",
        "isClass": true
      },
      {
        "date": "2021-01-11",
        "startTime": "11:00",
        "endTime": "11:50",
        "instructorName": "Yuta",
        "studentName": "Elliot",
        "classRoom": "hogehoge",
        "isClass": false
      },
      {
        "date": "2021-01-12",
        "startTime": "09:00",
        "endTime": "10:50",
        "instructorName": "Damina",
        "studentName": "Hide",
        "classRoom": "icecream",
        "isClass": true
      },
    ]
  }
];

  var _switchValueArray = [
    {"_switchValue1":false},
    {"_switchValue2":false},
    {"_switchValue3":false},
    {"_switchValue4":false},
    {"_switchValue5":false},
    {"_switchValue6":false},
    {"_switchValue7":false},
    {"_switchValue8":false},
    {"_switchValue9":false},
    {"_switchValue10":false},
    {"_switchValue11":false},
    {"_switchValue12":false},
    {"_switchValue13":false},
    {"_switchValue14":false},
    {"_switchValue15":false},
    {"_switchValue16":false},
  ];

var JSONdata = [

];


class CourseRegistration extends StatefulWidget {
  final VoidCallback shouldLogOut;

  CourseRegistration({Key key, this.shouldLogOut}) : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

//define date format
DateFormat format = DateFormat('yyyy-MM-dd');

class SampleStart extends State<CourseRegistration> {
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

//ToggleSwitch value
  var _switchValue01 = false;
  var _switchValue02 = false;
  var _switchValue03 = false;
  var _switchValue04 = false;
  var _switchValue05 = false;
  var _switchValue06 = false;
  var _switchValue07 = false;
  var _switchValue08 = false;
  var _switchValue09 = false;
  var _switchValue10 = false;
  var _switchValue11 = false;
  var _switchValue12 = false;
  var _switchValue13 = false;
  var _switchValue14 = false;
  var _switchValue15 = false;
  var _switchValue16 = false;



/*

swtichValueArray
[
  {
    "_switchVlue01":false
  },
  {
    "_switchVlue01":false
  },
  ...
]

for (let i =0; i < shapshot.swtichValueArray.length, i++){
for (let i =0; i < shapshot.data.length, i++){
  if (fetcheData.status = true)
  shapshot.swtichValueArray[i]["value"] = true;
}

  */

  //var _switchTitle = 'Switch Test';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class registration',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('skillTrain'),
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: Icon(Icons.arrow_back_ios)),
          ),
          body: Center(
            child: Column(
//          mainAxisSize: MainAxisSize.min,
//          crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FutureBuilder<List>(
                  future: futureApiResults,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      for (int i = 0; i < sampleData.length; i++) {
//calendar object
                        return Container(
                          height: 678,
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[

                                RaisedButton(
                                  onPressed: () => {_selectDate(context)},
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Colors.pink[300],
                                          Colors.purple[500],
                                          Colors.purple[700],
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: const Text('check Calendar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        )),
                                  ),
                                ),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[0]["_switchValue1"],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('09:00 - 09:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          print(value);
                                          _switchValueArray[0]["_switchValue1"] = value;
//                                          print(_switchValueArray);
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue03,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('10:00 - 10:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue03 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue04,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('11:00 - 11:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue04 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue05,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('12:00 - 12:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue05 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue06,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('13:00 - 13:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue06 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue07,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('14:00 - 14:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue07 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue08,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('15:00 - 15:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue08 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue09,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('16:00 - 16:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue09 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue10,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('17:00 - 17:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue10 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue11,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('18:00 - 18:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue11 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue12,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('19:00 - 19:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue12 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue13,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('20:00 - 20:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue13 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue14,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('21:00 - 21:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue14 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue15,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('22:00 - 22:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue15 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValue16,
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('23:00 - 23:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValue16 = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                RaisedButton(
                                  onPressed: () {

                                    //JSON data generate
                                        for (var i = 0; i <_switchValueArray.length; i++){
                                          var index = (i).toString();
                                          Map curerntObject =_switchValueArray[i];
                                          var objectKey = "_switchValue" + index;
                                          var newObject = {};
                                          print(objectKey);
                                          newObject[objectKey]=_switchValueArray[i][objectKey];
                                          JSONdata.add(newObject);
                                          print(curerntObject[objectKey]);
                                          print(_switchValueArray[i]);
                                        }
                                          print(_switchValueArray);
//                                          print(JSONdata);
                                    //////////////////////

                                  },
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Colors.pink[300],
                                          Colors.purple[500],
                                          Colors.purple[700],
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: const Text('Register',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                        //)
                      }

//calendar object
                    } else if (snapshot.connectionState !=
                        ConnectionState.done) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ],
            ),
          )),
    );
  }
}

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
