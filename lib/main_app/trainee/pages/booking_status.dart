import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/semantics.dart';
// ignore: unused_import
import '../home_page_trainee.dart';
// ignore: unused_import
import '../../../services/agora/video_session/index.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'booking_page.dart';

String traineeName = "";

class BookingStatus extends StatefulWidget {
  BookingStatus({Key key}) : super(key: key);
  @override
  SampleStart createState() => SampleStart();
}

//define date format
DateFormat format = DateFormat('yyyy-MM-dd');

class SampleStart extends State<BookingStatus> {
  Future<List> sessionResults;
  @override
  void initState() {
    super.initState();
    sessionResults = fetchSessionResults();
  }

  //calender object
  DateTime _date = new DateTime.now(); //defaulr date value
  String stringDate =
      format.format(new DateTime.now().subtract(Duration(days: 1)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booked sessions'),
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
                  if (snapshot.data[i]["user_username"] == traineeName
                      // && DateTime.parse(stringDate).isBefore(DateTime.parse(snapshot.data[i]["date"]))
                      ) {
                    classArray.add(snapshot.data[i]);
                  } else
                    print("something went wrong with fetched data");
                }

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
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        Text(
                                                            classArray[index][
                                                                    "start_time"] +
                                                                " - " +
                                                                classArray[
                                                                        index][
                                                                    "end_time"],
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            )),
                                                        Text(
                                                          "With " +
                                                              classArray[index][
                                                                  "trainer_username"],
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
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                          ))
                                                    ],
                                                  ),
                                                  new Spacer(),
                                                  // ButtonTheme(
                                                  //   minWidth: 30,
                                                  //   child: RaisedButton(
                                                  //       child: Icon(Icons
                                                  //           .video_call_rounded),
                                                  //       onPressed: () => {
                                                  //             Navigator.push(
                                                  //                 context,
                                                  //                 SlideLeftRoute(
                                                  //                     page:
                                                  //                         IndexPage()))
                                                  //           }),
                                                  // ),
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
    );
  }
}

// class BookingStatus extends StatelessWidget {
//   final int index;
//   BookingStatus({this.index});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("booking status"),
//         ),
//         body: ListView.builder(
//             itemBuilder: (BuildContext context, int index) {
//               return Card(
//                   child: Row(children: <Widget>[
//                 Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text("sample schedule",
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 25,
//                           )),
//                       Text("Instructor name",
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             fontSize: 20,
//                           )),
//                       Text("XX:00 - XX:30",
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             fontSize: 15,
//                           )),
//                     ]),
//                 new Spacer(),
//                 // RaisedButton(
//                 //   onPressed: () => {},
//                 //   textColor: Colors.white,
//                 //   padding: const EdgeInsets.all(0),
//                 //   child: Container(
//                 //     decoration: BoxDecoration(
//                 //       gradient: LinearGradient(
//                 //         colors: <Color>[
//                 //           Colors.pink[300],
//                 //           Colors.purple[500],
//                 //           Colors.purple[700],
//                 //         ],
//                 //       ),
//                 //     ),
//                 //     padding: const EdgeInsets.all(15),
//                 //     child: Icon(Icons.video_call_rounded),
//                 //   ),
//                 // ),
//                 RaisedButton(
//                     child: Icon(Icons.video_call_rounded),
//                     onPressed: () => {
//                           Navigator.push(
//                               context, SlideLeftRoute(page: IndexPage()))
//                         })
//               ]));
//             },
//             itemCount: 10));
//   }
// }
// ignore: missing_return
Future<List> fetchSessionResults() async {
  try {
    AuthUser res = await Amplify.Auth.getCurrentUser();
    traineeName = res.username;
    print("Current Use Name = " + res.username);

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
