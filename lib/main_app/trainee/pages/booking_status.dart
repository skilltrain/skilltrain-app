import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/semantics.dart';
// ignore: unused_import
import '../home_page_trainee.dart';
// ignore: unused_import
import '../../../services/agora/video_session/index_trainee.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:intl/intl.dart';
import '../../../utils/sliders.dart';
import '../pages/trainee_session_detail.dart';

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
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List classArray = [];
                for (int i = 0; i < snapshot.data.length; i++) {
                  if (snapshot.data[i]["user_username"] == traineeName &&
                      DateTime.parse(stringDate)
                          .isBefore(DateTime.parse(snapshot.data[i]["date"]))) {
                    classArray.add(snapshot.data[i]);
                    classArray.sort((a, b) {
                      var adate = a["date"] + a["start_time"];
                      var bdate = b["date"] + b["start_time"];
                      return adate.compareTo(bdate);
                    });
                  } else
                    print("something went wrong with fetched data");
                }

                return 
                Center(
                  child: Container(
                    color: Colors.purple,
                    height: MediaQuery.of(context).size.height - 87,
                    width:MediaQuery.of(context).size.width * 1.0,
                    
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(

                              child:Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
/*
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purple[500], width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white70,
                                ),
*/
                                child: GestureDetector(
                                    //画面遷移
                                    onTap: () => {

                                    Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                          page: TraineeSessionDetail(
                                              sessionID: classArray[index]['id'])),
                                    )

                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[

                                              new Spacer(),

                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      classArray[index]["date"] + "  " + 
                                                      classArray[index]["start_time"] + " - " +
                                                      classArray[index]["end_time"], 
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    Text(
                                                      "With " +
                                                          classArray[index][
                                                              "trainer_username"],
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ]),

/*
                                                    Text(
                                                        classArray[index]
                                                                ["start_time"] +
                                                            " - " +
                                                            classArray[index]
                                                                ["end_time"],
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                        )),
*/
                                              new Spacer(),

                                            /*
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Session Code",
                                                    textAlign: TextAlign.right,
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
                                            */

//                                              new Spacer(),

                                              /*
                                              ButtonTheme(
                                                minWidth: 30,
                                                child: RaisedButton(
                                                    child: Icon(Icons
                                                        .video_call_rounded),
                                                    onPressed: () => {
                                                          Navigator.push(
                                                              context,
                                                              SlideLeftRoute(
                                                                  page: IndexPageTrainee(
                                                                      instructorName:
                                                                          classArray[index]
                                                                              [
                                                                              "trainer_username"])))
                                                        }),
                                              ),
                                              */
                                            ]),
                                      ],
                                    ))));
                          },
                          itemCount: classArray.length,
                        )),

                        Center(child: Text("last update:" + "$_date")),

                      ],
                    )
                  )
                );
              } else if (snapshot.connectionState != ConnectionState.done) {
                return Container(
                    height: MediaQuery.of(context).size.height - 87,
                    decoration:
                        new BoxDecoration(color: Colors.deepPurple[100]),
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
            },
          ),
        ],
      ),
    );
  }
}

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
