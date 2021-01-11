import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; //json file convert

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:intl/intl.dart';
//import './session.dart';

/*
Future<void> GetUserObject () async{
  final user = await Auth.currentAuthenticatedUser();
}
*/

class InstructorBioUpdate extends StatefulWidget {
  final VoidCallback shouldLogOut;

  InstructorBioUpdate({Key key, this.shouldLogOut}) : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

class SampleStart extends State<InstructorBioUpdate> {
  Future<List> futureApiResults;
  @override
  void initState() {
    super.initState();
    futureApiResults = fetchApiResults();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class registration',
      home: Scaffold(        
        appBar: AppBar(
        title: Text('skillTrain'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: ()=> Navigator.pop(context,false),
          icon: Icon(Icons.arrow_back_ios)),
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

  try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      print("Current User Name = " + res.username);

      final response = await http.get(
      'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load API params');
      }

  } on AuthError catch (e) {
      print(e);
  }

}
