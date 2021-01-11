import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; //json file convert

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:intl/intl.dart';

String UserName = "";

const sampleData = [
  { 
    "instructor":"Yuta",
    "availability": [
      {
        "date": "2021-01-11",
        "startTime": "09:00",
        "endTime": "09:50",
        "instructorName": "Yuta",
        "studentName": "Hide",
        "classRoom":"hogehoge",
        "isClass":true
      },
      {
        "date": "2021-01-11",
        "startTime": "10:00",
        "endTime": "10:50",
        "instructorName": "Yuta",
        "studentName": "Elliot",
        "classRoom":"hogehoge"
        
      },
      {
        "date": "2021-01-12",
        "startTime": "09:00",
        "endTime": "10:50",
        "instructorName": "Damina",
        "studentName": "Hide",
        "classRoom":"icecream"
      },

    ]
  }
];

class InstructorUpcomingSchedule extends StatefulWidget {
  final VoidCallback shouldLogOut;

  InstructorUpcomingSchedule({Key key, this.shouldLogOut}) : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

//define date format
DateFormat format = DateFormat('yyyy-MM-dd');

class SampleStart extends State<InstructorUpcomingSchedule> {
  Future<List> futureApiResults;
  @override
  void initState() {
    super.initState();
    futureApiResults = fetchApiResults();
  }

//calendar object
  DateTime _date = new DateTime.now();//default date value
  String StringDate = format.format(new DateTime.now());//default date value for card
 
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360))
    );


  //Date format into String

    if(picked != null) setState(() => {
      _date = picked,
      StringDate = format.format(_date),
      print(_date),
      print(StringDate)
      });
      
  }
//calendar object


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class registration',
      home: Scaffold(        
        appBar: AppBar(
        title: Text('skillTrain'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: ()=> Navigator.pop(context,false),
          icon: Icon(Icons.arrow_back_ios)),
        ),
        body: Column(
          children:<Widget>[
            FutureBuilder<List>(
            future: futureApiResults,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                for (int i = 0; i < sampleData.length; i++){
                  if (sampleData[i]["instructor"]==UserName){
                    print("yes");
                    final List ClassArray = sampleData[i]["availability"];
              
//calendar object
              return Container(
                height: 678,
                width: double.infinity,
                padding: const EdgeInsets.all(50.0),
                child: Column(
                children: <Widget>[
                Center(child:Text("${_date}")),
                new RaisedButton(onPressed: () => 
                _selectDate(context), 
                child: new Text('日付選択'),),
  
                SizedBox(
                  height: 514,
                  child:
                  ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: GestureDetector(
                            //画面遷移
                            onTap: () => {
                                },
                            child: Column(
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(StringDate,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              ClassArray[index]["studentName"],
                                              textAlign: TextAlign.left,
                                            ),
                                          ]),
                                      new Spacer(),
                                          Text("USD /h ",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                    ]),
                              ],
                            )));
                  },
                  itemCount: ClassArray.length,
                )
                ),

                ],
              )
            );
          }
        }

//calendar object
              } else if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),

          ],
        ),
      ),
    );
  }
}

Future<List> fetchApiResults() async {

  try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      UserName = res.username;
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
