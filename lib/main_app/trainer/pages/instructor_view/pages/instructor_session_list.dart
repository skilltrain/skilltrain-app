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
import 'instructor_booked_session_detail_chat.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
              Column(
                children: [
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
                                  if (
                                      //snapshot.data[i]["user_username"].length == 0 &&
                                      DateTime.parse(stringDate).isBefore(
                                          DateTime.parse(
                                              snapshot.data[i]["date"]))) {
                                    classArray.add(snapshot.data[i]);
                                    classArray.sort((a, b) {
                                      var adate = a["date"] + a["start_time"];
                                      var bdate = b["date"] + b["start_time"];
                                      return adate.compareTo(bdate);
                                    });
                                    print("classArray data inside for loop" +
                                        classArray.toString());
                                  } else
                                    print(
                                        "something went wrong with fetched data");
                                }

                                return Column(
                                  children: <Widget>[
                                    ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        //card
                                        return sessionCard(
                                            trainer: true,
                                            name: classArray[index]
                                                            ["user_username"]
                                                        .length >
                                                    0
                                                ? classArray[index]
                                                    ["user_username"]
                                                : "Vacant",
                                            date: classArray[index]["date"],
                                            startTime: classArray[index]
                                                ["start_time"],
                                            endTime: classArray[index]
                                                ["end_time"],
                                            context: context,
                                            function: () => {
                                                  if (classArray[index]
                                                              ["user_username"]
                                                          .length >
                                                      0)
                                                    {
                                                      Navigator.push(
                                                          context,
                                                          SlideLeftRoute(
                                                              page: TrainerBookedSessionPage(
                                                                  id: classArray[index]
                                                                      ['id'],
                                                                  trainee: classArray[index][
                                                                      "user_username"],
                                                                  date: classArray[index]
                                                                      ["date"],
                                                                  startTime:
                                                                      classArray[index][
                                                                          "start_time"],
                                                                  endTime: classArray[
                                                                          index][
                                                                      "end_time"],
                                                                  description:
                                                                      classArray[index]
                                                                          [
                                                                          "description"],
                                                                  sessionCode:
                                                                      classArray[index]
                                                                          ["sessionCode"])))
                                                    }
                                                  else
                                                    {
                                                      Navigator.push(
                                                        context,
                                                        SlideLeftRoute(
                                                            page: InstructorSessionUpdate(
                                                                date: classArray[
                                                                        index]
                                                                    ["date"],
                                                                description: classArray[
                                                                        index][
                                                                    "description"],
                                                                startTime: classArray[
                                                                        index]
                                                                    [
                                                                    "start_time"],
                                                                endTime: classArray[
                                                                        index][
                                                                    "end_time"],
                                                                sessionID:
                                                                    classArray[
                                                                            index]
                                                                        ['id'])),
                                                      )
                                                    }
                                                });
                                      },
                                      itemCount: classArray.length,
                                    ),
                                    Text("last update:" + "$_date",
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                );
                              } else if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return Container(
                                    height:
                                        MediaQuery.of(context).size.height - 87,
                                    decoration: new BoxDecoration(
                                        color: Colors.deepPurple[100]),
                                    child: Center(
                                        child: CircularProgressIndicator()));
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
            ],
          )),
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
      print(response.body + "session list data");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load API params');
    }
  } on AuthError catch (e) {
    print(e);
  }
}
