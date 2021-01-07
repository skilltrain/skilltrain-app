import 'package:flutter/material.dart';
import 'package:skilltrain/main.dart';

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

class tutorial extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.pink[300], Colors.purple[700]])),
            child: Column(
              
              children: <Widget>[
              new Spacer(),
              Image.asset('assets/images/browseImage.gif', height: 500, fit:BoxFit.fill),
              Text('Find your favourite lesson', 
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 30,
                height: 2.5),              
              ),
              new Spacer(),
              RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  SlideRightRoute(page :tutorial2())
                );
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.black45,
                        Colors.black45,
                        Colors.black45,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Text('Learn more',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                  )),
                ),
              ),
              new Spacer(),

            ]
          ) 
      )
    );
  }
}

class tutorial2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.pink[300], Colors.purple[700]])),
            child: Column(
              
              children: <Widget>[
              new Spacer(),
              Image.asset('assets/images/biosImage.gif', height: 500, fit:BoxFit.fill),
              Text('Reserve the class room', 
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 30,
                height: 2.5),              
              ),
              new Spacer(),
              RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  SlideRightRoute(page :tutorial3())
                );
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.black45,
                        Colors.black45,
                        Colors.black45,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Text('Learn more',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                  )),
                ),
              ),
              new Spacer(),

            ]
          ) 
      )
    );
  }
}

class tutorial3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.pink[300], Colors.purple[700]])),
              child: Column(
                children: <Widget>[
                new Spacer(),
                Image.asset('assets/images/biosImage.png', height: 500, fit:BoxFit.fill),
                Text('Lesson video chat', 
                  style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  height: 2.5),              
                ),
                new Spacer(),
                RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.pink[300],
                          Colors.purple[500],
                          Colors.purple[700],
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Text("let's get started",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        )),
                  ),
                ),
                new Spacer(),
              ]
            ) 
        )
      );
  }
}