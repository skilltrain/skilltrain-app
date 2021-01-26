import 'package:flutter/material.dart';
import 'package:skilltrain/utils/sliders.dart';

class TutorialOne extends StatelessWidget {
  final VoidCallback shouldShowSession;
  final bool firstTime;

  const TutorialOne({Key key, this.shouldShowSession, this.firstTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.pink[300], Colors.purple[700]])),
            child: Column(children: <Widget>[
              new Spacer(),
              Image.asset('assets/images/browseImage.gif',
                  height: 500, fit: BoxFit.fill),
              Text(
                'Find your favourite lesson',
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
                      SlideLeftRoute(
                          page: TutorialTwo(
                        shouldShowSession: shouldShowSession,
                        firstTime: firstTime,
                      )));
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
            ])));
  }
}

class TutorialTwo extends StatelessWidget {
  final VoidCallback shouldShowSession;
  final bool firstTime;

  const TutorialTwo({Key key, this.shouldShowSession, this.firstTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.pink[300], Colors.purple[700]])),
            child: Column(children: <Widget>[
              new Spacer(),
              Image.asset('assets/images/biosImage.gif',
                  height: 500, fit: BoxFit.fill),
              Text(
                'Reserve the class room',
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
                      SlideLeftRoute(
                          page: TutorialThree(
                        shouldShowSession: shouldShowSession,
                        firstTime: firstTime,
                      )));
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
            ])));
  }
}

class TutorialThree extends StatelessWidget {
  final VoidCallback shouldShowSession;
  final bool firstTime;

  const TutorialThree({Key key, this.shouldShowSession, this.firstTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.pink[300], Colors.purple[700]])),
            child: Column(children: <Widget>[
              new Spacer(),
              Image.asset('assets/images/biosImage.png',
                  height: 500, fit: BoxFit.fill),
              Text(
                'Lesson video chat',
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
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  if (firstTime) {
                    shouldShowSession();
                  }
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
            ])));
  }
}
