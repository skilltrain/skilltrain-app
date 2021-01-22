import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/semantics.dart';
// ignore: unused_import
import '../home_page_trainee.dart';
// ignore: unused_import
import '../../../services/agora/video_session/index_trainee.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:intl/intl.dart';
import '../../../utils/sliders.dart';
import '../pages/trainee_session_detail.dart';
import '../../common/sessionCards.dart';

String traineeName = "";

class BookingStatus extends StatefulWidget {
  BookingStatus({Key key}) : super(key: key);
  @override
  SampleStart createState() => SampleStart();
}

//define date format
DateFormat format = DateFormat('yyyy-MM-dd');

class SampleStart extends State<BookingStatus> {
  Future<List> sessionResults;
  @override
  void initState() {
    super.initState();
    sessionResults = fetchSessionResults();
  }

  //calender object
  DateTime _date = new DateTime.now(); //defaulr date value
  String stringDate =
      format.format(new DateTime.now().subtract(Duration(days: 1)));

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black), //change your color here
        title: Text('Booked sessions'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: Icon(Icons.arrow_back)),
      ),
      body: 
      Container(
        width: double.infinity,
        color: Colors.purple,

        child: 

      Column(
        children: <Widget>[

          FutureBuilder<List>(
            future: sessionResults,
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List classArray = [];
                for (int i = 0; i < snapshot.data.length; i++) {
                  if (snapshot.data[i]["user_username"] == traineeName &&
                      DateTime.parse(stringDate)
                          .isBefore(DateTime.parse(snapshot.data[i]["date"]))) {
                    classArray.add(snapshot.data[i]);
                    classArray.sort((a, b) {
                      var adate = a["date"] + a["start_time"];
                      var bdate = b["date"] + b["start_time"];
                      return adate.compareTo(bdate);
                    });
                  } else
                    print("something went wrong with fetched data");
                }

                return 
                SingleChildScrollView(
                child: Center(

                  child: Container(
                    color: Colors.purple,
                    height: MediaQuery.of(context).size.height - 87,
                    width:MediaQuery.of(context).size.width * 0.9,
                    
                    child: Column(
                      children: <Widget>[

                        SizedBox(
                          child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {


                          //card
                            return 
                            
                            InkWell(
                              onTap: ()=>{
                                Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                          page: TraineeSessionDetail(
                                              sessionID: classArray[index]['id'])),
                                    )
                              },
                              child:
                              
                              sessionCards( name: classArray[index]["trainer_username"],
                                            date: classArray[index]["date"],
                                            startTime: classArray[index]["start_time"],
                                            endTime: classArray[index]["end_time"],
                                            context: context
                                          ),

                            /*
                              Card(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                height: 80,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      new Spacer(),

                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[

                                            new Spacer(),

                                          Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  width:MediaQuery.of(context).size.width *0.4,
                                                  child:Text("Trainer",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(fontSize: 15,),
                                                  ),
                                                ),
                                                Container(
                                                  width:MediaQuery.of(context).size.width *0.4,
                                                  child:Text(
                                                        classArray[index][
                                                            "trainer_username"],
                                                    style: TextStyle(fontSize: 20,),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                            new Spacer(),

                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    classArray[index]["date"] + "  ",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),

                                                  Text(
                                                    classArray[index]["start_time"] + " - " +
                                                    classArray[index]["end_time"], 
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),


                                                  ]),
                                              new Spacer(),
                                            ]),
                                          new Spacer(),
                                      ],
                                    )
                                    //)
                                    )

                              ),
                            */

                            );                            
//                            Card(
//                              child:
//                                  );


                          },
                          itemCount: classArray.length,
                        )
                        ),



                        Center(child: Text("last update:" + "$_date")),

                      ],
                    )
                  )
                )
                );
              } else if (snapshot.connectionState != ConnectionState.done) {
                return Container(
                    height: MediaQuery.of(context).size.height - 87,
                    decoration:
                        new BoxDecoration(color: Colors.deepPurple[100]),
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
            },
          ),
        ],
      ),
      )
    );
  }
}

// ignore: missing_return
Future<List> fetchSessionResults() async {
  try {
    AuthUser res = await Amplify.Auth.getCurrentUser();
    traineeName = res.username;
    print("Current Use Name = " + res.username);

    final response = await http.get(
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load API params');
    }
  } on AuthError catch (e) {
    print(e);
  }
}
