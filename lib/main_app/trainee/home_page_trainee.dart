import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skilltrain/main_app/common/dropdownwidget.dart';
import './pages/booking_status.dart';
import './pages/trainer_filter.dart';
import 'dart:async';
import 'dart:convert';
import './pages/instructor_bio.dart';
import 'package:amplify_core/amplify_core.dart';
import '../../utils/sliders.dart';
import '../common/fetchTrainers.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../common/headings.dart';

class HomePageTrainee extends StatefulWidget {
  final VoidCallback shouldLogOut;
  HomePageTrainee({Key key, this.shouldLogOut}) : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

// ignore: missing_return
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
      print(user);
      setState(() {});
      return;
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
    print(upcomingSessions);
  }

  Widget filterButton({String buttonText}) {
    return RaisedButton(
        onPressed: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              context: context,
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Column(children: [
                    sectionTitle(
                        title: "What type of trainer are you looking for?"),
                    MyDropdownButton(
                      value: genreFilter,
                      items: ["Weights", "Running", "Yoga", "Rowing", "Other"],
                      onChanged: (String item) {
                        setState(() {
                          genreFilter = item;
                        });
                      },
                    ),
                    MyDropdownButton(
                      value: priceFilter,
                      items: ["<¥500", "<¥1000", "<¥1500", "<¥2000", "<¥3000"],
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
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: Colors.black, width: 2)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                SlideRightRoute(
                                  page: TrainerFilter(genreFilter: genreFilter),
                                ));
                          },
                          child: Text("Search")),
                    ),
                    // trainerListView
                  ]);
                });
              });
        },
        child: Text(buttonText,
            style: TextStyle(fontSize: 15, color: Colors.grey[700])),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
        padding: EdgeInsets.all(15.0));
  }

  Widget build(BuildContext context) {
    Widget trainerListView({filterType, bool filter}) {
      return FutureBuilder(
        future: trainers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  List<Widget> stars = [];

                  for (var i = 0; i < snapshot.data[index]["avgRating"]; i++) {
                    stars.add(
                        Icon(Icons.star, color: Colors.yellow[700], size: 7));
                  }

                  if (filter) {
                    if (snapshot.data[index]["genre"] == filterType) {
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
                                            snapshot.data[index]
                                                ["profilePhoto"],
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
                                                snapshot.data[index]
                                                    ["username"],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: stars,
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
                    } else {
                      return Container();
                    }
                  } else {
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
                                            children: stars,
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
                  }
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
    }

    //Get upcoming sessions need to pass this to current bookings
    Widget upcomingSessionsView = FutureBuilder(
        future: upcomingSessions,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data.length > 0) {
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
          } else if (snapshot.connectionState == ConnectionState.waiting ??
              snapshot.connectionState == ConnectionState.active) {
            CircularProgressIndicator();
          }
          return Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "It looks like you don't have any upcoming sessions!"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Why don't you book some?"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: filterButton(
                      buttonText: "Find Someone to Help you Workout"),
                )
              ],
            ),
          ));
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
                filterButton(buttonText: "Find your Trainer")
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
          title: SizedBox(
              height: kToolbarHeight,
              child: Image.asset('assets/images/skillTrain-logo.png',
                  fit: BoxFit.scaleDown)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              headerSection,
              sectionTitle(title: "Top Rated"),
              trainerListView(filter: false, filterType: "null"),
              sectionTitle(title: "Upcoming Sessions"),
              upcomingSessionsView,
              sectionTitle(title: "Running"),
              trainerListView(filter: true, filterType: 'Running'),
              sectionTitle(title: "Yoga"),
              trainerListView(filter: true, filterType: 'Yoga'),
            ],
          ),
        ),
      ),
    );
  }
}
