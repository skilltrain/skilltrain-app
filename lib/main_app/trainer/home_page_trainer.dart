import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_core/amplify_core.dart';
import 'dart:async';
import 'dart:convert';
import '../../utils/sliders.dart';

import './pages/payment_signup.dart';
import './pages/instructor_view/instructor_view.dart';

class HomePageTrainer extends StatefulWidget {
  final VoidCallback shouldLogOut;
  HomePageTrainer({Key key, this.shouldLogOut}) : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

class SampleStart extends State<HomePageTrainer> {
  Future<List<dynamic>> futureApiResults;

  @override
  void initState() {
    super.initState();
    futureApiResults = fetchApiResults();
  }

  Future getUrl(url) async {
    try {
      S3GetUrlOptions options = S3GetUrlOptions(
          accessLevel: StorageAccessLevel.guest, expires: 30000);
      GetUrlResult result =
          await Amplify.Storage.getUrl(key: url, options: options);
      return result.url;
    } catch (e) {
      print(e.toString());
    }
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
                      fit: BoxFit.cover)),
            ),
            ListTile(
              title: Text('Instructor page'),
              onTap: () {
                Navigator.push(
                  context,
                  SlideLeftRoute(page: Instructor()),
                );
              },
            ),
            ListTile(
              title: Text('Payment signup'),
              onTap: () {
                Navigator.push(
                  context,
                  SlideLeftRoute(page: PaymentSignup()),
                );
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
          title: SizedBox(
                  height: kToolbarHeight,
                  child: Image.asset('assets/images/logo.png', fit: BoxFit.scaleDown)),
          centerTitle: true,
        ),
      ),
    );
  }

  Future<List> fetchApiResults() async {
    final response = await http.get(
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers');
    if (response.statusCode == 200) {
      var trainers = await json.decode(response.body);
      for (var trainer in trainers) {
        trainer["sessionPhoto"] = await getUrl(trainer["sessionPhoto"]);
        trainer["profilePhoto"] = await getUrl(trainer["profilePhoto"]);
      }
      return trainers;
    } else {
      throw Exception('Failed to load API params');
    }
  }
}
