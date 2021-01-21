import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/instructor_session_list.dart';
import '../../../../../utils/sliders.dart';

class InstructorSessionDetail extends StatefulWidget {
  //session ID passed by top page
  final String sessionID;
  InstructorSessionDetail({this.sessionID});

  @override
  _InstructorSessionDetailState createState() =>
      _InstructorSessionDetailState();
}

class _InstructorSessionDetailState extends State<InstructorSessionDetail> {
  int index;

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

  void getUrl() async {
    try {
      GetUrlResult result = await Amplify.Storage.getUrl(key: "myKey");
      print(result.url);
    } catch (e) {
      print(e.toString());
    }
  }

  Future getSessionData() async {
    String url =
        "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions/" +
            widget.sessionID;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map res = json.decode(response.body);

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
    print("前のページから受け取ったID" + widget.sessionID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Session detail"),
        ),
        body: FutureBuilder(
            future: getSessionData(),
            builder: (BuildContext context, snapshot) {
              print(snapshot);
              if (snapshot.hasData) {
                return SingleChildScrollView(
                    child: Container(
                        width: double.infinity,
                        child: Column(
                          children: [
/*
                                    Container(
                                      width:double.infinity,
                                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child:Text("Session detail", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                                    ),
*/

                            Container(
                                width: double.infinity,
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Text("Date",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15))),

                            ///Containr(
                            Column(children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Row(children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.24,
                                    child: Text("Year",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.24,
                                    child: Text("Month",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.24,
                                    child: Text("Date",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.24,
                                    child: Text("Start time",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                ]),
                              ),
                              Container(
                                width: double.infinity,
                                height: 30,
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purple[500], width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white70,
                                ),
                                child: Row(children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.24,
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
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.24,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.24,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.23,
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
                                        print("start time is" +
                                            _selectedStartTime);
                                        print(
                                            "end time  is" + _selectedEndTime);
                                        setState(() {
                                          _selectedStartTime = value;
                                        });
                                      },
                                    ),
                                  ),
                                ]),
                              ),
                            ]),

                            ///),

                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Text("Student name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 15)),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.purple[500], width: 1),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white70,
                              ),
                              child: Text(snapshot.data["user_username"],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 20)),
                            ),

                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Text("Video session ID",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 15)),
                            ),

                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.purple[500], width: 1),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white70,
                              ),
                              child: Text(snapshot.data["sessionCode"],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black54)),
                            ),

                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Text("Details",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 15)),
                            ),

                            Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.purple[500], width: 1),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white70,
                              ),
                              child: TextFormField(
                                  controller: TextEditingController(
                                      text: _detailsDescription),
                                  decoration: InputDecoration(
                                    labelText: _detailsDescription,
                                  ),
                                  maxLines: 22,
                                  minLines: 22,
                                  onChanged: (text) =>
                                      _detailsDescription = text),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: RaisedButton(
                                    onPressed: () async {

                                      if (snapshot.data["user_username"].length > 0){
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              title: Text("Already someone booked your lesson"),
                                              children: <Widget>[
                                                // コンテンツ領域
                                                SimpleDialogOption(
                                                  onPressed: () => 
                                                  Navigator.push(
                                                      context,
                                                      //SlideRightRoute(
                                                        //page: new SessionList(),
                                                        new MaterialPageRoute(builder: (context) => new SessionList()
                                                      )
                                                      )
                                                  ,
                                                  child: Text("You can't cancel unless student cancel your lesson"),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                      } else {
                                        final dynamic result =
                                            await deleteSessionDetails();
                                        if (result.statusCode == 201 || result.statusCode == 200) {
                                          print("course delete successful");

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              title: Text("Cancel request has been accepeted"),
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

                                          Navigator.pop(context, false);
                                        } else {
                                          print("course delete unsuccesful");
                                        }
                                      }
                                    },
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Colors.pink[300],
                                            Colors.purple[500],
                                            Colors.purple[700],
                                          ],
                                        ),
                                      ),
                                      child: const Text('Cancel',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                          )),
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: RaisedButton(
                                      onPressed: () async {
                                        final dynamic result =
                                            await updateSessionDetails();
                                        if (result.statusCode == 201) {
                                          print("update successful");
                                          Navigator.pop(context, false);
                                        } else {
                                          print("update unsuccesful");
                                        }
                                      },
                                      textColor: Colors.white,
                                      padding: const EdgeInsets.all(0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Colors.pink[300],
                                              Colors.purple[500],
                                              Colors.purple[700],
                                            ],
                                          ),
                                        ),
                                        child: const Text('Update',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                            )),
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        )));
              } else if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Text("データが存在しません");
              }
            }));
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
      }),
    );
  }

  Future<http.Response> deleteSessionDetails() async{
    String url = "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions/" + widget.sessionID;
    final response = await http.delete(url);
    return response;
  }

}
