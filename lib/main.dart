import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'amplifyconfiguration.dart';
import './sign_up.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  // Instantiate Amplify
  Amplify amplifyInstance = Amplify();

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    if (!mounted) return;

    // Add Pinpoint and Cognito Plugins
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    amplifyInstance.addPlugin(authPlugins: [authPlugin]);
    amplifyInstance.addPlugin(analyticsPlugins: [analyticsPlugin]);

    // Once Plugins are added, configure Amplify
    await amplifyInstance.configure(amplifyconfig);
    try {
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void _recordEvent() async {
    AnalyticsEvent event = AnalyticsEvent("test");
    event.properties.addBoolProperty("boolKey", true);
    event.properties.addDoubleProperty("doubleKey", 10.0);
    event.properties.addIntProperty("intKey", 10);
    event.properties.addStringProperty("stringKey", "stringValue");
    Amplify.Analytics.recordEvent(event: event);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "cyaaant",
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Navigator(
          pages: [MaterialPage(child: SignUpPage())],
          onPopPage: (route, result) => route.didPop(result),
        ));
    // home: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Amplify Core example app'),
    //     ),
    //     body: ListView(padding: EdgeInsets.all(10.0), children: <Widget>[
    //       Center(
    //         child: Column(children: [
    //           const Padding(padding: EdgeInsets.all(5.0)),
    //           Text(_amplifyConfigured ? "configured" : "not configured"),
    //           RaisedButton(
    //               onPressed: _amplifyConfigured ? _recordEvent : null,
    //               child: const Text('record event'))
    //         ]),
    //       )
    //     ])));
  }
}
