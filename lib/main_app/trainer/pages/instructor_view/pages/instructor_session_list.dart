import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; //json file convert
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:intl/intl.dart';
import 'package:skilltrain/main_app/common/headings.dart';
import 'package:skilltrain/main_app/common/sessionCards.dart';
// ignore: unused_import
import '../../../../../utils/sliders.dart';
// ignore: unused_import
import 'instructor_bio_update.dart';
// ignore: unused_import
import '../../../../../services/agora/video_session/index_trainer.dart';
import 'instructor_session_update.dart';

String trainerName = "";

class SessionList extends StatefulWidget {
  final VoidCallback shouldLogOut;

  SessionList({Key key, this.shouldLogOut}) : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

//define date format
DateFormat format = DateFormat('yyyy-MM-dd');

class SampleStart extends State<SessionList> {
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
      title: 'All session list',
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme:
                IconThemeData(color: Colors.black), //change your color here
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: Icon(Icons.arrow_back)),
          ),
          body: ListView(
            children: [
              Container(
                  padding: EdgeInsets.all(36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      blackHeading(
                          title: "Your Registered ",
                          underline: false,
                          purple: false),
                      blackHeading(
                          title: "Sessions", underline: true, purple: false)
                    ],
                  )),
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
                  padding: const EdgeInsets.only(top: 36.0, bottom: 36),
                  child: Column(
                    children: <Widget>[
                      FutureBuilder<List>(
                        future: sessionResults,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final List classArray = [];
                            for (int i = 0; i < snapshot.data.length; i++) {
                              if (snapshot.data[i]["user_username"].length ==
                                      0 &&
                                  DateTime.parse(stringDate).isBefore(
                                      DateTime.parse(
                                          snapshot.data[i]["date"]))) {
                                classArray.add(snapshot.data[i]);
                                classArray.sort((a, b) {
                                  var adate = a["date"] + a["start_time"];
                                  var bdate = b["date"] + b["start_time"];
                                  return adate.compareTo(bdate);
                                });
                              } else
                                print("something went wrong with fetched data");
                            }

                            return SingleChildScrollView(
                                child: Center(
                                    child: Container(
                                        child: Column(
                              children: <Widget>[
                                SizedBox(
                                    child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    //card
                                    return sessionCard(
                                        trainer: false,
                                        name: classArray[index]
                                            ["trainer_username"],
                                        date: classArray[index]["date"],
                                        startTime: classArray[index]
                                            ["start_time"],
                                        endTime: classArray[index]["end_time"],
                                        context: context,
                                        function: () => {
                                              Navigator.push(
                                                context,
                                                SlideLeftRoute(
                                                    page: InstructorSessionUpdate(
                                                        date: classArray[index]
                                                            ["date"],
                                                        description:
                                                            classArray[index]
                                                                ["description"],
                                                        startTime:
                                                            classArray[index]
                                                                ["start_time"],
                                                        endTime:
                                                            classArray[index]
                                                                ["end_time"],
                                                        sessionID:
                                                            classArray[index]
                                                                ['id'])),
                                              )
                                            });
//
                                  },
                                  itemCount: classArray.length,
                                )),
                                Center(
                                    child: Text("last update:" + "$_date",
                                        style: TextStyle(color: Colors.white))),
                              ],
                            ))));
                          } else if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Container(
                                height: MediaQuery.of(context).size.height - 87,
                                decoration: new BoxDecoration(
                                    color: Colors.deepPurple[100]),
                                child:
                                    Center(child: CircularProgressIndicator()));
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return Container(
                              child: Text("You have no upcoming sessions"));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )

//         body: Column(
//           children: <Widget>[
//             FutureBuilder<List>(
//               future: sessionResults,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   final List classArray = [];
//                   for (int i = 0; i < snapshot.data.length; i++) {
//                     if (snapshot.data[i]["trainer_username"] == trainerName &&
//                         DateTime.parse(stringDate).isBefore(
//                             DateTime.parse(snapshot.data[i]["date"]))) {
//                       print(stringDate);
//                       print(snapshot.data[i]["date"]);
//                       classArray.add(snapshot.data[i]);
//                       classArray.sort((a, b) {
//                         var adate = a["date"] + a["start_time"];
//                         var bdate = b["date"] + b["start_time"];
//                         return adate.compareTo(bdate);
//                       });
//                     } else
//                       print("something went wrong with fetched data");
//                   }

// //calendar object
//                   return Container(
//                       height: 678,
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(50.0),
//                       child: Column(
//                         children: <Widget>[
//                           Center(child: Text("last update:" + "$_date")),
//                           // new RaisedButton(
//                           //   onPressed: () => _selectDate(context),
//                           //   child: new Text('日付選択'),
//                           // ),
//                           SizedBox(
//                               height: 514,
//                               child: ListView.builder(
//                                 shrinkWrap: true,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return Card(
//                                       child: GestureDetector(
//                                           //画面遷移
//                                           onTap: () => {
//                                                 Navigator.push(
//                                                     context,
//                                                     SlideLeftRoute(
//                                                         page: InstructorSessionDetail(
//                                                             sessionID:
//                                                                 classArray[
//                                                                         index]
//                                                                     ['id']))),
//                                               },
//                                           child: Column(
//                                             children: <Widget>[
//                                               Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   children: <Widget>[
//                                                     Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: <Widget>[
//                                                           Text(
//                                                             classArray[index]
//                                                                 ["date"],
//                                                             textAlign:
//                                                                 TextAlign.left,
//                                                             style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               fontSize: 20,
//                                                             ),
//                                                           ),
//                                                           Text(
//                                                               classArray[index][
//                                                                       "start_time"] +
//                                                                   " - " +
//                                                                   classArray[
//                                                                           index]
//                                                                       [
//                                                                       "end_time"],
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .left,
//                                                               style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                                 fontSize: 16,
//                                                               )),
//                                                           /*
//                                                           Text(
//                                                             "With " +
//                                                                 classArray[
//                                                                         index][
//                                                                     "user_username"],
//                                                             textAlign:
//                                                                 TextAlign.left,
//                                                           ),
//                                                           */
//                                                         ]),
//                                                     new Spacer(),
//                                                     Column(
//                                                       children: <Widget>[
//                                                         Text(
//                                                           "Session Code",
//                                                           textAlign:
//                                                               TextAlign.right,
//                                                         ),
//                                                         Text(
//                                                             classArray[index]
//                                                                 ["sessionCode"],
//                                                             textAlign:
//                                                                 TextAlign.right,
//                                                             style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               fontSize: 15,
//                                                             ))
//                                                       ],
//                                                     ),
//                                                     new Spacer(),
//                                                     ButtonTheme(
//                                                       minWidth: 30,
//                                                       child: RaisedButton(
//                                                           child: Icon(Icons
//                                                               .video_call_rounded),
//                                                           onPressed: () => {
//                                                                 Navigator.push(
//                                                                     context,
//                                                                     SlideLeftRoute(
//                                                                         page:
//                                                                             IndexPageTrainer()))
//                                                               }),
//                                                     ),
//                                                   ]),
//                                             ],
//                                           )));
//                                 },
//                                 itemCount: classArray.length,
//                               )),
//                         ],
//                       ));

// //calendar object
//                 } else if (snapshot.connectionState != ConnectionState.done) {
//                   return CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text("${snapshot.error}");
//                 }
//                 return CircularProgressIndicator();
//               },
//             ),
//           ],
//         ),
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
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/$trainerName/sessions');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load API params');
    }
  } on AuthError catch (e) {
    print(e);
  }
}
