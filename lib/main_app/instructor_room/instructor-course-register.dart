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

var _switchValueTableNew = {};

var _switchValueTable = {
  "09:00": false,
  "10:00": false,
  "11:00": false,
  "12:00": false,
  "13:00": false,
  "14:00": false,
  "15:00": false,
  "16:00": false,
  "17:00": false,
  "18:00": false,
  "19:00": false,
  "20:00": false,
  "21:00": false,
  "22:00": false,
  "23:00": false,
};

var timeTable = [
  {"start_time": "09:00", "end_time": "09:50"},
  {"start_time": "10:00", "end_time": "10:50"},
  {"start_time": "11:00", "end_time": "11:50"},
  {"start_time": "12:00", "end_time": "12:50"},
  {"start_time": "13:00", "end_time": "13:50"},
  {"start_time": "14:00", "end_time": "14:50"},
  {"start_time": "15:00", "end_time": "15:50"},
  {"start_time": "16:00", "end_time": "16:50"},
  {"start_time": "17:00", "end_time": "17:50"},
  {"start_time": "18:00", "end_time": "18:50"},
  {"start_time": "19:00", "end_time": "19:50"},
  {"start_time": "20:00", "end_time": "20:50"},
  {"start_time": "21:00", "end_time": "21:50"},
  {"start_time": "22:00", "end_time": "22:50"},
  {"start_time": "23:00", "end_time": "23:50"},
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
  Future<ApiResults> resFromPostReq;

  @override
  void initState() {
    super.initState();
    futureApiResults = fetchApiResults();

    for (var i = 0; i < _switchValueArray.length; i++) {
      var newObject = {};
      newObject["trainer_username"] = "";
      newObject["user_username"] = "";
      newObject["id"] = stringDate + timeTable[i]["start_time"];
      newObject["sessionCode"] = stringDate + timeTable[i]["start_time"];
      newObject["date"] = stringDate;
      newObject["start_time"] = timeTable[i]["start_time"];
      newObject["end_time"] = timeTable[i]["end_time"];
      newObject["status"] = false;
      newObject["complete"] = false;
      resFromPostReq = fetchPostApiResults(newObject);
    }
    checkCurrentStatus();
  }

  void checkCurrentStatus() async {
    AuthUser res = await Amplify.Auth.getCurrentUser();
    userName = res.username;

    var url =
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/' +
            userName +
            "/sessions?date=" +
            stringDate;
    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    print("check current status");
//    print(response.body);
    print(decodedData);
    print(url);
    print("check current status");

    print("decoded data is ...");
    print(decodedData.length);
    print(decodedData);
    print("decoded data is ...");

    for (var i = 0; i < decodedData.length; i++) {
      /*
      if (decodedData[i]["start_time"] =="09:00"){
        _switchValueTable["09:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="10:00"){
        _switchValueTable["10:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="11:00"){
        _switchValueTable["11:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="12:00"){
        _switchValueTable["12:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="13:00"){
        _switchValueTable["13:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="14:00"){
        _switchValueTable["14:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="15:00"){
        _switchValueTable["15:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="16:00"){
        _switchValueTable["16:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="17:00"){
        _switchValueTable["17:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="18:00"){
        _switchValueTable["18:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="19:00"){
        _switchValueTable["19:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="20:00"){
        _switchValueTable["20:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="21:00"){
        _switchValueTable["21:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="22:00"){
        _switchValueTable["22:00"] = decodedData[i]["status"];
      } else if (decodedData[i]["start_time"] =="23:00"){
        _switchValueTable["23:00"] = decodedData[i]["status"];
      }
      */
      print("for is working");
    }

    setState(() {
      _switchValueTableNew = _switchValueTable;
    });

    print(_switchValueTableNew);
    print(_switchValueTable);
  }

  void putRequest(id, value) async {
    String url =
        "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions/" +
            id;

//PUT target records
    Map<String, String> headers = {'content-type': 'application/json'};
    var body = json.encode({
      'status': value,
    }); //214からきてる

    http.Response resp = await http.put(url, //215からきてるhttp.putのパラメーターとして使用
        headers: headers,
        body: body); //219からきてる
    if (resp.statusCode != 200 || resp.statusCode != 201) {
      setState(() {
        int statusCode = resp.statusCode;
        print("Failed to put $statusCode");
      });
      return;
    } else {
      print("PUT request sucessful");
      print(resp.statusCode);
    }
  }

  void callPostMethod(date) async {
    AuthUser res = await Amplify.Auth.getCurrentUser();
    userName = res.username;

    for (var i = 0; i < _switchValueArray.length; i++) {
      var newObject = {};
      newObject["trainer_username"] = userName;
      newObject["user_username"] = "";
      newObject["id"] = stringDate + timeTable[i]["start_time"] + userName;
      newObject["sessionCode"] =
          stringDate + timeTable[i]["start_time"] + userName; //sessionCodeが作られる
      newObject["date"] = stringDate;
      newObject["start_time"] = timeTable[i]["start_time"];
      newObject["end_time"] = timeTable[i]["end_time"];
      newObject["status"] = _switchValueArray[i];
      newObject["complete"] = false;

      fetchPostApiResults(newObject);
    }
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
            print(stringDate),
            callPostMethod(_date)
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
                                          print(
                                              stringDate + '09:00' + userName);
                                          _switchValueTableNew["09:00"] = value;
                                          print(_switchValueTable["09:00"]);

                                          putRequest(
                                              stringDate + '09:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '10:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '11:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '12:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '13:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '14:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '15:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '16:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '17:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '18:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '19:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '20:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '21:00' + userName,
                                              value);
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
                                          putRequest(
                                              stringDate + '22:00' + userName,
                                              value); //sessionIdになる
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
                                          putRequest(
                                              stringDate + '23:00' + userName,
                                              value);
//                          _switchTitle = stringDate;
                                        });
                                      }),
                                )),
                                RaisedButton(
                                  onPressed: () {
                                    var jsonData = [];
                                    //JSON data generate
                                    for (var i = 0;
                                        i < _switchValueArray.length;
                                        i++) {
                                      var newObject = {};
                                      newObject["trainer_username"] = userName;
                                      newObject["date"] = stringDate;
                                      newObject["start_time"] =
                                          timeTable[i]["start_time"];
                                      newObject["end_time"] =
                                          timeTable[i]["end_time"];
                                      newObject["status"] =
                                          _switchValueArray[i];

                                      //print(newObject);
                                      jsonData.add(newObject);
                                    }
                                    //print(_switchValueArray);
                                    print(jsonData);
                                    var jsonString = jsonEncode(jsonData);
//                                          print(_switchValueArray);
                                    print(jsonString);
//                                          print(jsonString);
//                                          print("jsonString");
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

// ignore: missing_return
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

class SampleRequest {
  final String trainerUsername;
  final String userUsername;
  final String id;
  final String sessionCode;
  final String date;
  final String startTime;
  final String endTime;
  final bool status;
  final bool complete;

  SampleRequest(
      {this.trainerUsername,
      this.userUsername,
      this.id,
      this.sessionCode,
      this.date,
      this.startTime,
      this.endTime,
      this.status,
      this.complete});
  Map<String, dynamic> toJson() => {
        'trainer_username': trainerUsername,
        'user_username': userUsername,
        'id': id,
        'sessionCode': sessionCode,
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
        'status': status,
        'complete': complete
      };
}

Future<ApiResults> fetchPostApiResults(object) async {
  AuthUser res = await Amplify.Auth.getCurrentUser();
  userName = res.username;

  var url =
      "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions";
  var request = new SampleRequest(
      trainerUsername: userName,
      userUsername: object["user_username"],
      id: object["id"],
      sessionCode: object["sessionCode"],
      date: object["date"],
      startTime: object["start_time"],
      endTime: object["end_time"],
      status: false,
      complete: false);
  final stringJSON = json.encode(request);
  print(stringJSON);
  final response = await http.post(url, body: json.encode(request),
//      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    print("new calendar record POST request successful");
    return ApiResults.fromJson(json.decode(response.body));
  } else {
    print(response.statusCode);
    throw Exception('Failed');
  }
}
