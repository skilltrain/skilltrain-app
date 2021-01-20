import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'dart:async';
import 'dart:convert';
import '../../utils/sliders.dart';
import './pages/payment_signup.dart';
import '../../services/agora/video_session/index_trainer.dart';
import '../trainer/pages/instructor_view/pages/instructor_register_course.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import '../trainer/pages/instructor_view/pages/instructor_bio_update.dart';
import '../trainer/pages/instructor_view/pages/instructor_session_detail.dart';
import '../trainer/pages/instructor_view/pages/instructor_session_list.dart';

String trainerName = "";

class HomePageTrainer extends StatefulWidget {
  final VoidCallback shouldLogOut;
  final List<CognitoUserAttribute> userAttributes;
  HomePageTrainer({Key key, this.shouldLogOut, this.userAttributes})
      : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

//define date format
DateFormat format = DateFormat('yyyy-MM-dd');

class SampleStart extends State<HomePageTrainer> {
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

  Future getUrl(url) async {
    try {
      S3GetUrlOptions options = S3GetUrlOptions(
          accessLevel: StorageAccessLevel.guest, expires: 30000);
      GetUrlResult result =
          await Amplify.Storage.getUrl(key: url, options: options);
      return result.url;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill train class list',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
          drawer: Drawer(
              child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text(''),
                decoration: BoxDecoration(
                    color: Colors.orange[50],
                    image: DecorationImage(
                        image: AssetImage("assets/images/crossfit.jpg"),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                title: Text('Class registration'),
                onTap: () {
                  Navigator.push(
                    context,
                    SlideLeftRoute(page: InstructorRegisterCourse()),
                  );
                },
              ),
              ListTile(
                title: Text('Update session details'),
                onTap: () {
                  Navigator.push(
                    context,
                    SlideLeftRoute(page: SessionList()),
                  );
                },
              ),
              ListTile(
                title: Text('Bio update'),
                onTap: () {
                  Navigator.push(
                    context,
                    SlideLeftRoute(page: InstructorBioUpdate()),
                  );
                },
              ),
              ListTile(
                title: Text('Payment signup'),
                onTap: () {
                  Navigator.push(
                    context,
                    SlideLeftRoute(
                        page: PaymentSignup(
                            userAttributes: widget.userAttributes)),
                  );
                },
              ),
              ListTile(
                title: Text('Log out'),
                onTap: widget.shouldLogOut,
              ),
            ],
          ) // Populate the Drawer in the next step.
              ),
          appBar: AppBar(
            title: SizedBox(
                height: kToolbarHeight,
                child: Image.asset('assets/images/skillTrain-logo.png',
                    fit: BoxFit.scaleDown)),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                FutureBuilder<List>(
                  future: sessionResults,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List classArray = [];
                      for (int i = 0; i < snapshot.data.length; i++) {
                        if (snapshot.data[i]["trainer_username"] ==
                                trainerName &&
                            snapshot.data[i]["user_username"].length > 0 &&
                            DateTime.parse(stringDate).isBefore(
                                DateTime.parse(snapshot.data[i]["date"]))) {
                          print(stringDate);
                          print(snapshot.data[i]["date"]);
                          classArray.add(snapshot.data[i]);
                          classArray.sort((a, b) {
                            var adate = a["date"] + a["start_time"];
                            var bdate = b["date"] + b["start_time"];
                            return adate.compareTo(bdate);
                          });
                        } else
                          print("something went wrong with fetched data");
                      }

//calendar object
                      return Container(
//                      height: 678,
                          width: double.infinity,
                          padding: const EdgeInsets.all(50.0),
                          child: Column(
                            children: <Widget>[
                              Text('Welcome\n$trainerName!',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w800,
                                      fontSize: 50)),
                              // new RaisedButton(
                              //   onPressed: () => _selectDate(context),
                              //   child: new Text('日付選択'),
                              // ),
                              SizedBox(
//                              height: 514,
                                  child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                      child: GestureDetector(
                                          //画面遷移
                                          onTap: () => {
                                           // print("testing tap action"),
                                            Navigator.push(context,SlideLeftRoute(page:InstructorSessionDetail(sessionID: snapshot.data[index]['id']))),
                                          },
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
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          Text(
                                                              classArray[index][
                                                                      "start_time"] +
                                                                  " - " +
                                                                  classArray[
                                                                          index]
                                                                      [
                                                                      "end_time"],
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              )),
                                                          Text(
                                                            "With " +
                                                                classArray[
                                                                        index][
                                                                    "user_username"],
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
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                            ))
                                                      ],
                                                    ),
                                                    new Spacer(),
                                                    ButtonTheme(
                                                      minWidth: 30,
                                                      child: RaisedButton(
                                                          child: Icon(Icons
                                                              .video_call_rounded),
                                                          onPressed: () => {
                                                                Navigator.push(
                                                                    context,
                                                                    SlideLeftRoute(
                                                                        page:
                                                                            IndexPageTrainer()))
                                                              }),
                                                    ),
                                                  ]),
                                            ],
                                          )));
                                },
                                itemCount: classArray.length,
                              )),
                              Center(child: Text("last update:" + "$_date")),
                            ],
                          ));

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

  // ignore: missing_return
  Future<List> fetchSessionResults() async {
    try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      trainerName = res.username;
      print("Current User Name = " + res.username);

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

  Future<List> fetchApiResults() async {
    final response = await http.get(
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers');
    if (response.statusCode == 200) {
      var trainers = await json.decode(response.body);
      for (var trainer in trainers) {
        trainer["sessionPhoto"] = await getUrl(trainer["sessionPhoto"]);
        trainer["profilePhoto"] = await getUrl(trainer["profilePhoto"]);
      }
      return trainers;
    } else {
      throw Exception('Failed to load API params');
    }
  }
}
