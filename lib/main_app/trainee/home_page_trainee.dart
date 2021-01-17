import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skilltrain/main_app/components/dropdownwidget.dart';
import './pages/booking_status.dart';
import './pages/trainer_filter.dart';
import 'dart:async';
import 'dart:convert';
import './pages/instructor_bio.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_core/amplify_core.dart';
import '../../utils/sliders.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

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

Future<List> fetchUserSessions() async {
  try {
    AuthUser res = await Amplify.Auth.getCurrentUser();
    String user = res.username;
    print("Current Use Name = " + res.username);
    final response = await http.get(
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/users/$user/sessions');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load API params');
    }
  } on AuthError catch (e) {
    print(e);
  }
}

Future getUrl(key) async {
  try {
    S3GetUrlOptions options =
        S3GetUrlOptions(accessLevel: StorageAccessLevel.guest, expires: 30000);
    GetUrlResult result =
        await Amplify.Storage.getUrl(key: key, options: options);
    return result.url;
  } catch (e) {
    print(e.toString());
  }
}

class SampleStart extends State<HomePageTrainee> {
  String user;
  Future trainers;
  Future<List> upcomingSessions;
  List listOfTrainers;

  String genreFilter = "Weights";
  String priceFilter = "<¥500";

  getCurrentUser() async {
    try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      user = res.username;
      return user;
    } on AuthError catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    trainers = fetchTrainers();
    upcomingSessions = fetchUserSessions();
  }

  @override
  Widget build(BuildContext context) {
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

    //Get upcoming sessions need to pass this to current bookings
    Widget upcomingSessionsView = FutureBuilder(
        future: upcomingSessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return (Text("You dont have any Sessions"));
          } else {
            return ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 5),
                  child: ListTile(
                      title: Text(snapshot.data[index]["trainer_username"]),
                      subtitle: Text(snapshot.data[index]['start_time'] +
                          snapshot.data[index]['end_time'])),
                );
              },
              itemCount: 3,
            );
          }
        });

    //Header widget for homescreen
    Widget headerSection = Container(
        margin: EdgeInsets.only(top: 30, left: 50, right: 50, bottom: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text('Welcome\n$user!',
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
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(children: [
                              _sectionTitle(
                                  title:
                                      "What type of trainer are you looking for?"),
                              MyDropdownButton(
                                value: genreFilter,
                                items: [
                                  "Weights",
                                  "Running",
                                  "Yoga",
                                  "Rowing",
                                  "Other"
                                ],
                                onChanged: (String item) {
                                  setState(() {
                                    genreFilter = item;
                                  });
                                },
                              ),
                              MyDropdownButton(
                                value: priceFilter,
                                items: [
                                  "<¥500",
                                  "<¥1000",
                                  "<¥1500",
                                  "<¥2000",
                                  "<¥3000"
                                ],
                                onChanged: (String item) {
                                  setState(() {
                                    priceFilter = item;
                                  });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 40, left: 60, right: 60, bottom: 0),
                                child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        side: BorderSide(
                                            color: Colors.black, width: 2)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          SlideRightRoute(
                                            page: TrainerFilter(),
                                          ));
                                    },
                                    child: Text("Search")),
                              ),
                              // trainerListView
                            ]);
                          });
                        });
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
        )),
        appBar: AppBar(
          title: Text('skillTrain'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              headerSection,
              _sectionTitle(title: "Top Rated"),
              trainerListView,
              _sectionTitle(title: "Upcoming Sessions"),
              upcomingSessionsView,
              _sectionTitle(title: "Running"),
              trainerListView,
              _sectionTitle(title: "Weights"),
              trainerListView
            ],
          ),
        ),
      ),
    );
  }
}
