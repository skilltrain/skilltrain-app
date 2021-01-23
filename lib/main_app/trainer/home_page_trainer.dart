import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:skilltrain/main_app/common/headings.dart';
import 'package:skilltrain/main_app/common/sessionCards.dart';
import 'dart:async';
import 'dart:convert';
import '../../utils/sliders.dart';
import '../trainer/pages/instructor_view/pages/instructor_register_course.dart';
import 'package:intl/intl.dart';
import '../trainer/pages/instructor_view/pages/instructor_bio_update.dart';
import './pages/payment_signup.dart';
import '../trainer/pages/instructor_view/pages/instructor_session_list.dart';
import 'pages/instructor_view/pages/instructor_booked_session_detail_chat.dart';

String trainerName = "";

class HomePageTrainer extends StatefulWidget {
  final VoidCallback shouldLogOut;
  final List<CognitoUserAttribute> userAttributes;
  final CognitoUser cognitoUser;
  HomePageTrainer(
      {Key key, this.shouldLogOut, this.userAttributes, this.cognitoUser})
      : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

//define date format
DateFormat format = DateFormat('yyyy-MM-dd');

class SampleStart extends State<HomePageTrainer> {
  Future<List> sessionResults;
  bool signedUpPayment = false;

  @override
  void initState() {
    super.initState();
    sessionResults = fetchSessionResults();
    widget.userAttributes.forEach((attribute) {
      if (attribute.getName() == 'custom:paymentSignedUp') {
        if (attribute.getValue() == 'true') {
          signUpPayment();
        }
      }
    });
  }

  void signUpPayment() {
    setState(() {
      signedUpPayment = true;
    });
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
              signedUpPayment
                  ? ListTile(
                      title: Text('Add your bank details'),
                      trailing: new Icon(
                        Icons.check_circle_sharp,
                        color: Colors.green,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideLeftRoute(
                              page: PaymentSignup(
                                  userAttributes: widget.userAttributes,
                                  cognitoUser: widget.cognitoUser,
                                  signUpComplete: signUpPayment,
                                  active:
                                      !signedUpPayment //whether the page is usable or not!
                                  )),
                        );
                      })
                  : ListTile(
                      title: Text('Add your bank details'),
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideLeftRoute(
                              page: PaymentSignup(
                                  userAttributes: widget.userAttributes,
                                  cognitoUser: widget.cognitoUser,
                                  signUpComplete: signUpPayment,
                                  active: !signedUpPayment)),
                        );
                      }),
              ListTile(
                title: Text('Bio update'),
                onTap: () {
                  Navigator.push(
                    context,
                    SlideLeftRoute(page: InstructorBioUpdate()),
                  );
                },
              ),
              signedUpPayment ? const Divider(height: 10) : Container(),
              signedUpPayment
                  ? ListTile(
                      title: Text(
                        'Class registration',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideLeftRoute(page: InstructorRegisterCourse()),
                        );
                      },
                    )
                  : ListTile(
                      title: Text(
                      'Class registration',
                      style: (TextStyle(color: Colors.grey)),
                    )),
              signedUpPayment
                  ? ListTile(
                      title: Text('Update session details'),
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideLeftRoute(page: SessionList()),
                        );
                      },
                    )
                  : Container(), // Empty container so it doesnt even appear
              ListTile(
                title: Text('Log out'),
                onTap: widget.shouldLogOut,
              ),
            ],
          )),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Color(0xFFFFFFFF),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        blackHeading(
                            title: "Welcome", underline: false, purple: false),
                        blackHeading(
                            title: trainerName, underline: true, purple: false)
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
                                if (snapshot.data[i]["user_username"].length >
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
                                  print(
                                      "something went wrong with fetched data");
                              }

                              return SingleChildScrollView(
                                  child: Center(
                                      child: Container(
                                          child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 36.0, bottom: 36),
                                    child: Row(
                                      children: [
                                        Icon(Icons.fitness_center,
                                            color: Colors.white, size: 18),
                                        sectionTitle(
                                            title: "  Upcoming Sessions"),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      child: ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      //card
                                      return sessionCard(
                                          trainer: true,
                                          name: classArray[index]
                                              ["user_username"],
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
                                                        page: InstructorSessionDetail(
                                                            sessionID:
                                                                classArray[
                                                                        index]
                                                                    ['id']))),
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
                    } else if (snapshot.connectionState !=
                        ConnectionState.done) {
                      return Container(
                          height: MediaQuery.of(context).size.height - 87,
                          decoration:
                              new BoxDecoration(color: Colors.deepPurple[100]),
                          child: Center(child: CircularProgressIndicator()));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Container(
                        height: MediaQuery.of(context).size.height - 87,
                        decoration:
                            new BoxDecoration(color: Colors.deepPurple[100]),
                        child: Center(child: CircularProgressIndicator()));
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
}
