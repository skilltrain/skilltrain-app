import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import './booking_status.dart';
import './tutorial_flow.dart';
import './instructor_bio.dart';

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
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class HomePage extends StatefulWidget {
  final VoidCallback shouldLogOut;

  HomePage({Key key, this.title, this.shouldLogOut}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  loadJson() async {
    String data =
        await rootBundle.loadString('assets/sample_data/home_page_sample.json');
    return json.decode(data);
  }

  @override
  Widget build(BuildContext context) {
    final listSample2 = loadJson();
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.orange[50],
            ),
          ),
          ListTile(
            title: Text('Booking status'),
            onTap: () => {
              Navigator.push(
                context,
                SlideRightRoute(page: BookingStatus()),
              )
            },
          ),
          ListTile(
            title: Text('Tutorial'),
            onTap: () {
              Navigator.push(
                context,
                SlideRightRoute(page: Tutorial()),
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("skillTrain"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: GestureDetector(
                  //画面遷移
                  onTap: () => {
                        Navigator.push(
                          context,
                          SlideLeftRoute(page: InstructorBio(index: index)),
                        )
                      },
                  child: Column(
                    children: <Widget>[
                      Image.network(listSample2[index]["classPhoto"]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    listSample2[index]["instructor"],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    listSample2[index]["genre"],
                                    textAlign: TextAlign.left,
                                  ),
                                ]),
                            new Spacer(),
                            Text(listSample2[index]["price"].toString(),
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
        itemCount: listSample2.length,
      ),
    );
  }
}

class Sample {
  void main() {}
}
