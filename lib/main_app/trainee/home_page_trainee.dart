import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
import '../trainer/pages/instructor_view/pages/instructor_session_detail.dart';

class HomePageTrainee extends StatefulWidget {
  final VoidCallback shouldLogOut;
  HomePageTrainee({Key key, this.shouldLogOut}) : super(key: key);

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
        final data = (json.decode(response.body));
        if (data.length < 4) {
          setState(() {
            _trainersLoading = false;
            _sessionsLoading = false;
          });
        }
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
    try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      _user = res.username;
      setState(() {});
      return;
    } on AuthError catch (e) {
      print(e);
    }
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
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: Colors.black, width: 2)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                SlideRightRoute(
                                  page:
                                      TrainerFilter(genreFilter: _genreFilter),
                                ));
                          },
                          child: Text("Search")),
                    ),
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
        future: _trainers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('snapshot');

            return Container(
              height: 200,
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
                                          Text(
                                            snapshot.data[index]["price"]
                                                    .toString() +
                                                'p/s',
                                          )
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
          if (snapshot.data != null && snapshot.data.length > 0) {
            return ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print(index);
                if (index == 2) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    sessionsLoaded();
                  });
                }

                return Card(
                  margin:
                      EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 5),
                  child: ListTile(
                      title: Text(snapshot.data[index]["trainer_username"]),
                      subtitle: Text(snapshot.data[index]['start_time'] + "-" +
                          snapshot.data[index]['end_time']),
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideLeftRoute(
                              page: InstructorSessionDetail(
                                  sessionID: snapshot.data[index]['id'])),
                        );
                      }),
                );
              },
              itemCount: 3,
            );
          } else if (snapshot.connectionState == ConnectionState.waiting ??
              snapshot.connectionState == ConnectionState.active) {
            Container(
              height: 100,
            );
          }
          return Container(
              height: 200,
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
                Text('Welcome\n$_user!',
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
          body: ModalProgressHUD(
              child: SingleChildScrollView(
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
              inAsyncCall: (_trainersLoading || _sessionsLoading),
              color: Colors.deepPurple,
              progressIndicator: CircularProgressIndicator())),
    );
  }
}
