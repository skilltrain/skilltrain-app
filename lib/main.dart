import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';

/*
IMPORTANT - THIS LINE WILL NOT COMPILE
That is intentional
You need to generate your own amplifyconfiguration.dart
for accessing your own AWS resources.
You will use the Amplify CLI tool for that.  Please read the
README.md contained within the root of this project to learn
about what you'll need to do.
 */
import 'amplifyconfiguration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Amplify amplify = Amplify();
  bool _isAmplifyConfigured = false;

  @override
  initState() {
    super.initState();
    _initAmplifyFlutter();
  }

  void _initAmplifyFlutter() async {
    AmplifyAuthCognito auth = AmplifyAuthCognito();

    amplify.addPlugin(
      authPlugins: [auth],
    );

    // Initialize AmplifyFlutter
    await amplify.configure(amplifyconfig);

    setState(() {
      _isAmplifyConfigured = true;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Amplify App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
