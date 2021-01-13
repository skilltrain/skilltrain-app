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
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

var timeTable = [
  {
    "start_time":"09:00",
    "end_time":"09:50"
  },
  {
    "start_time":"10:00",
    "end_time":"10:50"
  },
  {
    "start_time":"11:00",
    "end_time":"11:50"
  },
  {
    "start_time":"12:00",
    "end_time":"12:50"
  },
  {
    "start_time":"13:00",
    "end_time":"13:50"
  },
  {
    "start_time":"14:00",
    "end_time":"14:50"
  },
  {
    "start_time":"15:00",
    "end_time":"15:50"
  },
  {
    "start_time":"16:00",
    "end_time":"16:50"
  },
  {
    "start_time":"17:00",
    "end_time":"17:50"
  },
  {
    "start_time":"18:00",
    "end_time":"18:50"
  },
  {
    "start_time":"19:00",
    "end_time":"19:50"
  },
  {
    "start_time":"20:00",
    "end_time":"20:50"
  },
  {
    "start_time":"21:00",
    "end_time":"21:50"
  },
  {
    "start_time":"22:00",
    "end_time":"22:50"
  },
  {
    "start_time":"23:00",
    "end_time":"23:50"
  },
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

  Future<List> GeneratedPutData;
  @override
    void callPutMethod(data)async{
    final GeneratedPutData = await putData();
    print("put method is called");
    print(GeneratedPutData);
//    print(data);
//    Future<String> putData(data) async{
//      await print(data);
//    }
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
                                      value: _switchValueArray[0],
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
                                          _switchValueArray[0] = value;
//                                          print(_switchValueArray);
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[1],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('10:00 - 10:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[1] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[2],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('11:00 - 11:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[2] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[3],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('12:00 - 12:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[3] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[4],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('13:00 - 13:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[4] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[5],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('14:00 - 14:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[5] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[6],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('15:00 - 15:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[6] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[7],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('16:00 - 16:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[7] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[8],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('17:00 - 17:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[8] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[9],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('18:00 - 18:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[9] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[10],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('19:00 - 19:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[10] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[11],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('20:00 - 20:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[11] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[12],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('21:00 - 21:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[12] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[13],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('22:00 - 22:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[13] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                Card(
                                    child: Container(
                                  width: double.infinity,
                                  child: SwitchListTile(
                                      value: _switchValueArray[14],
                                      title: Text(
                                        stringDate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('23:00 - 23:50'),
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueArray[14] = value;
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),

                                RaisedButton(
                                  onPressed: () {
                                        var JSONdata = [];
                                    //JSON data generate
                                        for (var i = 0; i <_switchValueArray.length; i++){
                                          var newObject = {
                                          };                                         
                                          newObject["trainer_username"] = userName;
                                          newObject["date"] = stringDate;
                                          newObject["start_time"] = timeTable[i]["start_time"];
                                          newObject["end_time"] = timeTable[i]["end_time"];
                                          newObject["status"] = _switchValueArray[i];
                                          
                                          //print(newObject);
                                          JSONdata.add(newObject);
                                        }
                                          //print(_switchValueArray);
                                          print(JSONdata);
                                          var JSONstring = jsonEncode(JSONdata);
//                                          print(_switchValueArray);
                                          print(JSONstring);                                          
//                                          print(JSONstring);
//                                          print("JSONstring");
                                          callPutMethod(JSONstring);
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

Future<List> putData() async {
  try {
    final response = await http.get(
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers');
    print("now accessing to Future<List>putData");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load API params');
    }
  } on AuthError catch (e) {
    print(e);
  }
}

