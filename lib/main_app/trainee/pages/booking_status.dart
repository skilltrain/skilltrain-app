import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/semantics.dart';
import 'package:skilltrain/main_app/common/buttons.dart';
import 'package:skilltrain/main_app/common/headings.dart';
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
import '../../common/sessionCards.dart';
import 'trainee_session_detail_chat.dart';

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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.all(36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      blackHeading(
                          title: "Your Booked ",
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
                              if (snapshot.data[i]["user_username"] ==
                                      traineeName &&
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
                                    return InkWell(
                                        onTap: () => {
                                              Navigator.push(
                                                context,
                                                SlideLeftRoute(
                                                    page: TraineeSessionDetail(
                                                        sessionID:
                                                            classArray[index]
                                                                ['id'])),
                                              )
                                            },
                                        child: sessionCard(
                                            trainer: false,
                                            name: classArray[index]
                                                ["trainer_username"],
                                            date: classArray[index]["date"],
                                            startTime: classArray[index]
                                                ["start_time"],
                                            endTime: classArray[index]
                                                ["end_time"],
                                            context: context,
                                            function: () => {
                                                  Navigator.push(
                                                    context,
                                                    SlideLeftRoute(
                                                        page: TraineeSessionDetailsPage(
                                                            sessionID: snapshot
                                                                    .data[index]
                                                                ['id'])),
                                                  )
                                                }));
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
          ),
        ));
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
