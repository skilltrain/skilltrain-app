import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:skilltrain/main_app/common/buttons.dart';
import 'package:skilltrain/main_app/common/dropdownwidget.dart';
import 'package:skilltrain/main_app/common/tutorial_flow.dart';
import 'package:skilltrain/services/agora/live_stream/pre_index_livestream.dart';
import 'package:skilltrain/main_app/common/sessionCards.dart';
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
import 'pages/trainee_session_detail_chat.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class HomePageTrainee extends StatefulWidget {
  final VoidCallback shouldLogOut;
  final List<CognitoUserAttribute> userAttributes;
  HomePageTrainee({Key key, this.shouldLogOut, this.userAttributes})
      : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

class SampleStart extends State<HomePageTrainee> {
  String _user;
  Future _trainers;
  Future<List> _upcomingSessions;
  String _genreFilter = "Weights";
  String _priceFilter = "<¥500";
  bool _trainersLoading = true;
  bool _sessionsLoading = true;

  // ignore: missing_return
  Future<List> fetchUserSessions() async {
    try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      String user = res.username;
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

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    if (_trainersLoading && _sessionsLoading) {
      _trainers = fetchTrainers();
      _upcomingSessions = fetchUserSessions();
    }
  }

  // Check the state of the other boolean, if both are false, update page
  // This is complicated logic to check if both trainers and sessions are loaded
  void trainersLoaded() {
    if (!_trainersLoading)
      return; // Because the futures keep reloading and running the builder, which runs this method
    _trainersLoading = false;
    if (!_sessionsLoading)
      // If both are false, both sessions + trainers are loaded, so call setState with these
      // aysnc loader disappears when both booleans are false and setState is called
      setState(() {
        _sessionsLoading = false;
        _trainersLoading = false;
      });
  }

  // Both methods are talking to each other
  void sessionsLoaded() {
    if (!_sessionsLoading) return;
    _sessionsLoading = false;
    if (!_trainersLoading)
      setState(() {
        _sessionsLoading = false;
        _trainersLoading = false;
      });
  }

  void getCurrentUser() async {
    widget.userAttributes.forEach((attribute) {
      if (attribute.getName() == 'given_name') {
        setState(() {
          _user = attribute.getValue();
        });
      }
    });
  }

  Widget filterButton({String buttonText}) {
    return ElevatedButton(
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
                    Padding(
                      padding: const EdgeInsets.all(36),
                      child: blackHeading(
                          title: "What type of trainer are you looking for?",
                          underline: false,
                          purple: false),
                    ),
                    MyDropdownButton(
                      value: _genreFilter,
                      items: ["Weights", "Running", "Yoga", "Rowing", "Other"],
                      onChanged: (String item) {
                        setState(() {
                          _genreFilter = item;
                        });
                      },
                    ),
                    MyDropdownButton(
                      value: _priceFilter,
                      items: ["<¥500", "<¥1000", "<¥1500", "<¥2000", "<¥3000"],
                      onChanged: (String item) {
                        setState(() {
                          _priceFilter = item;
                        });
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: 40, left: 60, right: 60, bottom: 0),
                        child: cyanButton(
                            text: "Search",
                            function: () {
                              Navigator.push(
                                  context,
                                  SlideRightRoute(
                                    page: TrainerFilter(
                                        genreFilter: _genreFilter),
                                  ));
                            })
                        // child: FlatButton(
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(25.0),
                        //         side: BorderSide(color: Colors.black, width: 2)),
                        // onPressed: () {
                        //   Navigator.push(
                        //       context,
                        //       SlideRightRoute(
                        //         page:
                        //             TrainerFilter(genreFilter: _genreFilter),
                        //       ));
                        // },
                        //     child: Text("Search")),
                        ),
                  ]);
                });
              });
        },
        child: Text(buttonText,
            style: TextStyle(fontSize: 15, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          primary: Colors.cyanAccent, // background
          onPrimary: Colors.white, // foreground
        ));
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(8),
    // ),
    // color: Colors.white,
    // padding: EdgeInsets.all(15.0));
  }

  Widget build(BuildContext context) {
    Widget trainerListView({filterType, bool filter}) {
      return FutureBuilder(
        future: _trainers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  print(index);

                  // If it's the last element, the element says 'all trainers loaded'
                  // It has to be called as PostFrameCallback as, if the sessions have also loaded
                  // , then a setState call is required, but setState cannot be called while the
                  // widget is building like in here...
                  if (index == snapshot.data.length - 1) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      trainersLoaded();
                    });
                  }
                  List<Widget> stars = [];

                  for (var i = 0; i < snapshot.data[index]["avgRating"]; i++) {
                    stars.add(
                        Icon(Icons.star, color: Colors.cyanAccent, size: 12));
                  }

                  // If the user isn't signed up yet (the only way they can add a price),
                  // return an empty container which does nothing
                  if (snapshot.data[index]['price'] == null) {
                    return Container();
                  }

                  if (filter) {
                    if (snapshot.data[index]["genre"] == filterType) {
                      return SizedBox(
                        width: 170,
                        child: Card(
                          elevation: 4,
                          child: InkWell(
                              splashColor: Colors.purple,
                              onTap: () => {
                                    // Navigator.push(context,
                                    //     MaterialPageRoute(builder: (_) {
                                    //   return InstructorBio(
                                    //       data: snapshot.data[index],
                                    //       index: index);
                                    // }))

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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          child: Image.network(
                                              snapshot.data[index]
                                                  ["profilePhoto"],
                                              height: 120,
                                              width: 180,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                snapshot.data[index]
                                                    ["firstName"],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: stars,
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data[index]["genre"],
                                              style: TextStyle(
                                                  color: Colors.grey[700]),
                                            ),
                                            Text(
                                                "¥" +
                                                    snapshot.data[index]
                                                            ["price"]
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[700]),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
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
                    return Hero(
                      tag: index,
                      child: SizedBox(
                        width: 170,
                        child: Card(
                          elevation: 4,
                          child: InkWell(
                              splashColor: Colors.purple,
                              onTap: () => {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return InstructorBio(
                                          data: snapshot.data[index],
                                          index: index);
                                    }))

                                    // Navigator.push(
                                    //   context,
                                    //   SlideRightRoute(
                                    //       page: InstructorBio(
                                    //           data: snapshot.data[index],
                                    //           index: index)),
                                    // )
                                  },
                              child: Column(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Image.network(
                                            snapshot.data[index]
                                                ["profilePhoto"],
                                            height: 120,
                                            width: 180,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            snapshot.data[index]["firstName"],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: stars,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data[index]["genre"],
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                        Text(
                                            "¥" +
                                                snapshot.data[index]["price"]
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              )),
                        ),
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
          return
              // Empty container same height as card while loading
              Container(
            height: 200,
          );
        },
      );
    }

    //Get upcoming sessions need to pass this to current bookings
    Widget upcomingSessionsView = FutureBuilder(
        future: _upcomingSessions,
        builder: (context, snapshot) {
          final List classArray = [];
          if (snapshot.data != null && snapshot.data.length > 0) {
            // If there is data, we want as many items as possible to show
            // as long as it is no more than 3:
            // int itemCount = classArray.length;
            // added by hide
            DateTime _date = new DateTime.now(); //default date value
            for (int i = 0; i < snapshot.data.length; i++) {
              if (snapshot.data[i]["user_username"].length > 0 &&
                  DateTime.parse(_date.toString()).isBefore(DateTime.parse(
                      snapshot.data[i]["date"] +
                          " " +
                          snapshot.data[i]["end_time"]))) {
                classArray.add(snapshot.data[i]);
                classArray.sort((a, b) {
                  var adate = a["date"] + a["start_time"];
                  var bdate = b["date"] + b["start_time"];
                  return adate.compareTo(bdate);
                });
              }
            }

            if (classArray.length > 0) {
              int itemCount = 3;
              // added by hide
              if (classArray.length < 3) {
                // The builder will return as many items as are present
                itemCount = classArray.length;
              }
              return ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  print(index);
                  // The LAST element will have a post-build callback to update the widget's state
                  if (index == classArray.length - 1) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      sessionsLoaded();
                    });
                  }

                  return sessionCard(
                      trainer: false,
                      name: classArray[index]["trainer_username"],
                      date: classArray[index]["date"],
                      startTime: classArray[index]["start_time"],
                      endTime: classArray[index]["end_time"],
                      context: context,
                      function: () => {
                            print(itemCount),
                            Navigator.push(
                              context,
                              SlideLeftRoute(
                                  page: TraineeSessionDetailsPage(
                                      sessionID: classArray[index]['id'],
                                      trainer: classArray[index]
                                          ["trainer_username"],
                                      sessionCode: classArray[index]
                                          ["sessionCode"],
                                      date: classArray[index]["date"],
                                      startTime: classArray[index]
                                          ["start_time"],
                                      endTime: classArray[index]["end_time"],
                                      description: classArray[index]
                                          ["description"])),
                            )
                          });
                },
                itemCount: itemCount,
              );
            }
          } else if (classArray != null && classArray.length == 0) {
            // If the user has no sessions yet, call sessionsLoaded
            // This is the difference between no data and data.length == 0
            sessionsLoaded();
          } else
          // (snapshot.connectionState == ConnectionState.waiting ??
          //     snapshot.connectionState == ConnectionState.active)
          {
            Container(
              height: 100,
            );
          }
          return Container(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                    "It looks like you don't have any upcoming sessions!",
                    style: TextStyle(fontSize: 24)),
              ),
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Text("Why don't you book some?",
                    style: TextStyle(fontSize: 24)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: filterButton(
                    buttonText: "Find Someone to Help you Workout"),
              )
            ],
          ));
        });

    //Header widget for homescreen
    Widget headerSection = Container(
        margin: EdgeInsets.only(top: 30, left: 50, right: 50, bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            blackHeading(title: "Welcome", underline: false, purple: true),
            blackHeading(title: '$_user!', underline: true, purple: true),
            SizedBox(height: 15),
            Row(
              children: [
                Text('Who are you\ngonna train with\ntoday?',
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
                Spacer(),
                filterButton(buttonText: "Find your Trainer")
              ],
            ),
          ],
        ));

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
              ListTile(
                title: Text('Tutorial'),
                onTap: () {
                  Navigator.push(
                    context,
                    SlideLeftRoute(
                        page: TutorialOne(
                      firstTime: false,
                    )),
                  );
                },
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
                title: Text('Live Stream'),
                onTap: () => {
                  Navigator.push(
                    context,
                    SlideLeftRoute(page: IndexPageLiveStream()),
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
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Color(0xFFFFFFFF),
            title: Image.asset(
              'assets/icon/icon.png',
              height: 36.0,
              width: 36.0,
            ),
          ),
          body: ModalProgressHUD(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    headerSection,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.purple,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(36.0),
                            child: Row(
                              children: [
                                Icon(Icons.fitness_center,
                                    color: Colors.white, size: 18),
                                sectionTitle(title: "  Top Rated Trainers"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 36),
                            child: trainerListView(
                                filter: false, filterType: "null"),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 30, left: 50, right: 50, bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          blackHeading(
                              title: "Upcoming",
                              underline: false,
                              purple: true),
                          blackHeading(
                              title: "Sessions!",
                              underline: true,
                              purple: false),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 54.0),
                      child: upcomingSessionsView,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.purple,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(36.0),
                            child: Row(
                              children: [
                                Icon(Icons.directions_run,
                                    color: Colors.white, size: 18),
                                sectionTitle(title: "  Running Trainers"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 36),
                            child: trainerListView(
                                filter: true, filterType: 'Running'),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 36.0, right: 36, bottom: 36, top: 14),
                                child: Row(
                                  children: [
                                    Icon(Icons.self_improvement,
                                        color: Colors.white, size: 18),
                                    sectionTitle(title: "  Yoga Trainers"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 36),
                                child: trainerListView(
                                    filter: true, filterType: 'Yoga'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              inAsyncCall: (_trainersLoading || _sessionsLoading),
              color: Colors.deepPurple,
              progressIndicator: CircularProgressIndicator())),
    );
  }
}
