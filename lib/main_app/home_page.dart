import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; //json file convert
import './booking_status.dart';
import './instructor_bio.dart';
import './tutorial_flow.dart';
import './instructor_room/instructor.dart';

//Page transition animation from left to right
class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

//Page transition animation from left to right
class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class HomePage extends StatefulWidget {
  final VoidCallback shouldLogOut;

  HomePage({Key key, this.shouldLogOut}) : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

class SampleStart extends State<HomePage> {
  Future<List> futureApiResults;
  @override
  void initState() {
    super.initState();
    futureApiResults = fetchApiResults();
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
                    fit: BoxFit.cover)
                
              ),
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
              title: Text('Instructor page '),
              onTap: () {
                    Navigator.push(
                      context,
                      SlideLeftRoute(page: Instructor()),
                    );
              },
            ),
            ListTile(
              title: Text('Sign up'),
              onTap: () => {
                // Eliot - not sure what this does
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => _MyApp(),
                //   ),
                // )
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
          title: Text('skillTrain'),
          centerTitle: true,
        ),
        body: Center(
          child: FutureBuilder<List>(
            future: futureApiResults,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: GestureDetector(
                            //画面遷移
                            onTap: () => {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: InstructorBio(data: snapshot.data[index],index: index)),
                                  )
                                },
                            child: Column(
                              children: <Widget>[
                                Image.network(
                                    snapshot.data[index]["classPhoto"]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data[index]
                                                  ["instructor"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data[index]["genre"],
                                              textAlign: TextAlign.left,
                                            ),
                                          ]),
                                      new Spacer(),
                                      Text(
                                          snapshot.data[index]["price"]
                                              .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 35,
                                          )),
                                      Text("USD /h ",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                    ]),
                              ],
                            )));
                  },
                  itemCount: snapshot.data.length,
                );
              } else if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

Future<List> fetchApiResults() async {
  final response = await http.get(
      'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers');
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load API params');
  }
}
