import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:http/http.dart' as http;
import 'package:skilltrain/main_app/common/headings.dart';
import 'dart:convert';
import '../pages/instructor_session_list.dart';

class InstructorSessionUpdate extends StatefulWidget {
  //session ID passed by top page
  final String sessionID;
  final String date;
  final String startTime;
  final String endTime;
  final String description;
  InstructorSessionUpdate(
      {this.sessionID,
      this.date,
      this.startTime,
      this.endTime,
      this.description});

  @override
  _InstructorSessionUpdateState createState() =>
      _InstructorSessionUpdateState();
}

class _InstructorSessionUpdateState extends State<InstructorSessionUpdate> {
  int index;
  Map sessionData;
  // ignore: unused_field
  String _uploadProfilePicFileResult = '';

  //Calendar parameters
  String year = "";
  String month = "";
  String day = "";
  String startTime = "";
  String endTime = "";
  bool status = false;
  bool complete = false;

  String testMessage = "abcdefghijk";

  String _selectedYear = "Year";
  String _selectedMonth = "Month";
  String _selectedDate = "Day";
  String _selectedStartTime = "Start time";
  String _selectedEndTime = "Start time";
  String _detailsDescription = "details";

  // ignore: unused_field
  String _user = "";
  void _getCurrentUser() async {
    try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      _user = res.username;
    } on AuthError catch (e) {
      print(e);
    }
  }

  Future getSessionData() async {
    String url =
        "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions/" +
            widget.sessionID;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map res = json.decode(response.body);
      print(res);
      _selectedYear = res["date"].substring(0, res["date"].length - 6);
      _selectedMonth = res["date"].substring(5, res["date"].length - 3);
      _selectedDate = res["date"].substring(8, res["date"].length);
      _selectedStartTime = res["start_time"];

      if (res["description"] == null) {
        _detailsDescription = "Describe here about your session";
      } else {
        _detailsDescription = res["description"];
      }

      print(res);

      return res;
    } else {
      throw Exception('Failed to load API params');
    }
  }

  void initState() {
    super.initState();
    _getCurrentUser();
    _selectedYear = widget.date.substring(0, widget.date.length - 6);
    _selectedMonth = widget.date.substring(5, widget.date.length - 3);
    _selectedDate = widget.date.substring(8, widget.date.length);
    _selectedStartTime = widget.startTime;
    _selectedEndTime = widget.endTime;
    _detailsDescription = widget.description;

    print("前のページから受け取ったID" + widget.sessionID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme:
              IconThemeData(color: Colors.black), //change your color here
          centerTitle: true,
          title: Image.asset(
            'assets/icon/icon.png',
            height: 36.0,
            width: 36.0,
          ),
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
                            title: "Edit", underline: false, purple: false),
                        blackHeading(
                            title: "Session", underline: true, purple: false)
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 36.0, right: 36.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        primary: Colors.yellow, // background
                        onPrimary: Colors.black, // foreground
                      ),
                      onPressed: () async {
                        final dynamic result = await deleteSessionDetails();
                        if (result.statusCode == 201 ||
                            result.statusCode == 200) {
                          print("course delete successful");

                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title:
                                    Text("Cancel request has been accepeted"),
                                children: <Widget>[
                                  // コンテンツ領域
                                  SimpleDialogOption(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SessionList()),
                                    ),
                                    child: Text(""),
                                  ),
                                ],
                              );
                            },
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SessionList()),
                          ); //
//                          Navigator.pop(context, false);
                        } else {
                          print("course delete unsuccesful");
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete),
                          Text(" Delete",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      )),
                )
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: Colors.white, size: 18),
                            sectionTitle(title: " Date"),
                          ],
                        ),
                      ),
                      Column(children: [
                        Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text(_selectedYear,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
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
                              Flexible(
                                flex: 1,
                                child: Container(
                                  child: Container(
                                    child: DropdownButton<String>(
                                      hint: Text(_selectedMonth,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
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
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                          ),
                                        );
                                      }).toList(),
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
                              Flexible(
                                flex: 1,
                                child: Container(
                                    child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text(_selectedDate,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
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
                                  onChanged: (value) {
                                    day = value;
                                    print("month is" + day);
                                    setState(() {
                                      _selectedDate = value;
                                    });
                                  },
                                )),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  // width: MediaQuery.of(context)
                                  //         .size
                                  //         .width *
                                  //     0.35,
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text(_selectedStartTime,
                                        textAlign: TextAlign.center),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
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
                                    onChanged: (value) {
                                      _selectedStartTime = value;
                                      _selectedEndTime =
                                          _selectedStartTime.substring(0, 3) +
                                              "50";
                                      print(
                                          "start time is" + _selectedStartTime);
                                      print("end time  is" + _selectedEndTime);
                                      setState(() {
                                        _selectedStartTime = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ]),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
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
                          border:
                              Border.all(color: Colors.purple[500], width: 1),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                            controller: TextEditingController(
                                text: _detailsDescription),
                            decoration: InputDecoration(),
                            maxLines: 8,
                            minLines: 8,
                            onChanged: (text) => _detailsDescription = text),
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
                            final dynamic result = await updateSessionDetails();
                            if (result.statusCode == 201) {
                              print("update successful");
//                              Navigator.pop(context, false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SessionList()),
                              );
                            } else {
                              print("update unsuccesful");
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.update),
                              Text(" Update",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          )),
                    ],
                  ),
                )),
          ],
        ));
  }

  Future<http.Response> updateSessionDetails() {
    String url =
        "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions/" +
            widget.sessionID;

    return http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'description': _detailsDescription,
        'start_time': _selectedStartTime,
        'end_time': _selectedEndTime,
        'date': _selectedYear + "-" + _selectedMonth + "-" + _selectedDate,
      }),
    );
  }

  Future<http.Response> deleteSessionDetails() async {
    String url =
        "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions/" +
            widget.sessionID;
    final response = await http.delete(url);
    return response;
  }
}
