import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './pages/trainer_filter.dart';
import 'dart:async';
import 'dart:convert';
import 'pages/booking_status.dart';
import './pages/instructor_bio.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_core/amplify_core.dart';
import '../../utils/sliders.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

// test added by Hide
import '../../services/agora/video_session/index_trainer.dart';

class HomePageTrainee extends StatefulWidget {
  final VoidCallback shouldLogOut;
  HomePageTrainee({Key key, this.shouldLogOut}) : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

//Fetch All Trainer Data
Future fetchTrainers() async {
  final response = await http.get(
      'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers');

  if (response.statusCode == 200) {
    var res = await jsonDecode(response.body);
    for (var trainer in res) {
      trainer["sessionPhoto"] = await getUrl(trainer["sessionPhoto"]);
      trainer["profilePhoto"] = await getUrl(trainer["profilePhoto"]);
    }
    return res;
  } else {
    throw Exception('Failed to load album');
  }
}

Future fetchSessions(user) async {
  final response = await http.get(
      'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/users/$user/sessions');
  if (response.statusCode == 200) {
    var res = await jsonDecode(response.body);
    return res;
  } else {
    throw Exception('Failed to load album');
  }
}

Future getUrl(url) async {
  try {
    S3GetUrlOptions options =
        S3GetUrlOptions(accessLevel: StorageAccessLevel.guest, expires: 30000);
    GetUrlResult result =
        await Amplify.Storage.getUrl(key: url, options: options);
    return result.url;
  } catch (e) {
    print(e.toString());
  }
}

class SampleStart extends State<HomePageTrainee> {
  String user = "";
  Future trainers;
  Future upcomingSessions;
  List listOfTrainers;

  getCurrentUser() async {
    try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      user = res.username;
      return;
    } on AuthError catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    print(user);
    trainers = fetchTrainers();
    upcomingSessions = fetchSessions(user);
    print(upcomingSessions);
  }

  @override
  Widget build(BuildContext context) {
    //Title widget for homescreen
    Widget titleSection = Container(
        margin: EdgeInsets.only(top: 30, left: 50, right: 50, bottom: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text('Welcome\nDamian!',
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w800,
                        fontSize: 50)),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text('Who are you\ngonna train with\ntoday?',
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 20)),
                Spacer(),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        SlideRightRoute(
                          page: TrainerFilter(),
                        ));
                  },
                  child: Text('Find your Trainer',
                      style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.white,
                  padding: EdgeInsets.all(15.0),
                )
              ],
            ),
          ],
        ));

    //Reuseable title widget
    Widget _sectionTitle({String title}) {
      return Container(
          alignment: Alignment.bottomLeft,
          margin: EdgeInsets.symmetric(horizontal: 50),
          padding: EdgeInsets.only(top: 20),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey[900],
                fontSize: 35,
                fontWeight: FontWeight.w800),
          ));
    }

    ;

    Widget trainerListView = FutureBuilder(
      future: trainers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 150,
                  child: Card(
                    child: InkWell(
                        splashColor: Colors.purple,
                        onTap: () => {
                              Navigator.push(
                                context,
                                SlideRightRoute(
                                    page: InstructorBio(
                                        data: snapshot.data[index],
                                        index: index)),
                              )
                            },
                        child: Container(
                            padding: EdgeInsets.all(0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Image.network(
                                      snapshot.data[index]["profilePhoto"],
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.fill),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          snapshot.data[index]["username"],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.yellow[700],
                                              size: 7),
                                          Icon(Icons.star,
                                              color: Colors.yellow[700],
                                              size: 7),
                                          Icon(Icons.star,
                                              color: Colors.yellow[700],
                                              size: 7),
                                          Icon(Icons.star,
                                              color: Colors.black, size: 7),
                                          Icon(Icons.star,
                                              color: Colors.black, size: 7),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(snapshot.data[index]["genre"]),
                                    Text(snapshot.data[index]["price"]
                                            .toString() +
                                        'p/s')
                                  ],
                                )
                              ],
                            ))),
                  ),
                );
                // return Text(
                //   snapshot.data[index]["username"],
                //   style: TextStyle(fontSize: 50),
                // );
              },
              itemCount: snapshot.data.length,
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );

    Widget upcomingSessionsView = FutureBuilder(
        future: upcomingSessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Text(snapshot.data[index]["start_time"]);
              },
            );
          }
        });

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
              title: Text('Booking status'),
              onTap: () => {
                Navigator.push(
                  context,
                  SlideLeftRoute(page: BookingStatus()),
                )
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
                  child: Image.asset('assets/images/skillTrain-logo.png', fit: BoxFit.scaleDown)),
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(child: titleSection),
            Container(child: _sectionTitle(title: "Top Rated")),
            Container(child: trainerListView),
            Container(child: _sectionTitle(title: "Upcoming Sessions")),
            // Container(child: upcomingSessionsView),
          ],
        ),
      ),
    );
  }

  // Future<List> fetchApiResults() async {
  //   final response = await http.get(
  //       'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers');
  //   if (response.statusCode == 200) {
  //     var trainers = await json.decode(response.body);
  //     for (var trainer in trainers) {
  //       trainer["sessionPhoto"] = await getUrl(trainer["sessionPhoto"]);
  //       trainer["profilePhoto"] = await getUrl(trainer["profilePhoto"]);
  //     }
  //     return trainers;
  //   } else {
  //     throw Exception('Failed to load API params');
  //   }
  // }
}
