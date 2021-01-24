// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:flutter/material.dart';
// import 'package:amplify_core/amplify_core.dart';
// import 'package:amplify_storage_s3/amplify_storage_s3.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../../utils/sliders.dart';
// import '../../../services/agora/video_session/index_trainee.dart';

// class TraineeSessionDetail extends StatefulWidget {
//   //session ID passed by top page
//   final String sessionID;
//   TraineeSessionDetail({this.sessionID});

//   @override
//   _InstructorSessionDetailState createState() =>
//       _InstructorSessionDetailState();
// }

// class _InstructorSessionDetailState extends State<TraineeSessionDetail> {
//   int index;
//   // pic urls
//   //Leave this here I will use later
//   // ignore: unused_field
//   String _uploadProfilePicFileResult = '';

//   //Calendar parameters
//   String year = "";
//   String month = "";
//   String day = "";
//   String startTime = "";
//   String endTime = "";
//   bool status = false;
//   bool complete = false;

//   String testMessage = "abcdefghijk";
//   String _detailsDescription = "details";

//   // ignore: unused_field
//   String _user = "";
//   void _getCurrentUser() async {
//     try {
//       AuthUser res = await Amplify.Auth.getCurrentUser();
//       _user = res.username;
//     } on AuthError catch (e) {
//       print(e);
//     }
//   }

//   void getUrl() async {
//     try {
//       GetUrlResult result = await Amplify.Storage.getUrl(key: "myKey");
//       print(result.url);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future getSessionData() async {
//     String url =
//         "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions/" +
//             widget.sessionID;
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       Map res = json.decode(response.body);

//       if (res["description"] == null) {
//         _detailsDescription = "Describe here about your session";
//       } else {
//         _detailsDescription = res["description"];
//       }

//       print(res);

//       return res;
//     } else {
//       throw Exception('Failed to load API params');
//     }
//   }

//   void initState() {
//     super.initState();
//     _getCurrentUser();
//     print("前のページから受け取ったID" + widget.sessionID);
//     print("trainee_session_detailに到達");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Session detail"),
//         ),
//         body: FutureBuilder(
//             future: getSessionData(),
//             builder: (BuildContext context, snapshot) {
//               print(snapshot);
//               if (snapshot.hasData) {
//                 return SingleChildScrollView(
//                     child: Container(
//                         width: double.infinity,
//                         child: Column(
//                           children: [
//                             Container(
//                                 width: double.infinity,
//                                 margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                                 child: Text("Date",
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(fontSize: 15))),
//                             Container(
//                               width: double.infinity,
//                               margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: Colors.purple[500], width: 1),
//                                 borderRadius: BorderRadius.circular(5),
//                                 color: Colors.white70,
//                               ),
//                               child: Text(snapshot.data["date"],
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                       color: Colors.black54, fontSize: 20)),
//                             ),
//                             Container(
//                                 width: double.infinity,
//                                 margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                                 child: Text("Start time",
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(fontSize: 15))),
//                             Container(
//                               width: double.infinity,
//                               margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: Colors.purple[500], width: 1),
//                                 borderRadius: BorderRadius.circular(5),
//                                 color: Colors.white70,
//                               ),
//                               child: Text(snapshot.data["start_time"],
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                       color: Colors.black54, fontSize: 20)),
//                             ),
//                             Container(
//                               width: double.infinity,
//                               margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                               child: Text("Instuctor name",
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(fontSize: 15)),
//                             ),
//                             Container(
//                               width: double.infinity,
//                               margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: Colors.purple[500], width: 1),
//                                 borderRadius: BorderRadius.circular(5),
//                                 color: Colors.white70,
//                               ),
//                               child: Text(snapshot.data["trainer_username"],
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                       color: Colors.black54, fontSize: 20)),
//                             ),
//                             Row(
//                               children: [
//                                 Column(children: [
//                                   Container(
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.5,
//                                     margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                                     child: Text("Video session ID",
//                                         textAlign: TextAlign.left,
//                                         style: TextStyle(fontSize: 15)),
//                                   ),
//                                   Container(
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.5,
//                                     margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: Colors.purple[500], width: 1),
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: Colors.white70,
//                                     ),
//                                     child: Text(snapshot.data["sessionCode"],
//                                         textAlign: TextAlign.left,
//                                         style: TextStyle(
//                                             fontSize: 20,
//                                             color: Colors.black54)),
//                                   ),
//                                 ]),
//                                 Column(
//                                   children: [
//                                     Container(
//                                       height: 17,
//                                     ),
//                                     ButtonTheme(
//                                       minWidth:
//                                           MediaQuery.of(context).size.width *
//                                               0.45,
//                                       height: 25,
//                                       child: RaisedButton(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(5.0),
//                                             //side: BorderSide(color: Colors.red)
//                                           ),
//                                           child: Icon(Icons.video_call_rounded),
//                                           onPressed: () => {
//                                                 Navigator.push(
//                                                     context,
//                                                     SlideLeftRoute(
//                                                         page: IndexPageTrainee(
//                                                             instructorName:
//                                                                 snapshot.data[
//                                                                     "trainer_username"])))
//                                               }),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               width: double.infinity,
//                               margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                               child: Text("Details",
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(fontSize: 15)),
//                             ),
//                             Container(
//                                 width: double.infinity,
//                                 height: 420,
//                                 margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                       color: Colors.purple[500], width: 1),
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: Colors.white70,
//                                 ),
//                                 child: Text(_detailsDescription)),
//                             Container(
//                               margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                               child: RaisedButton(
//                                 onPressed: () async {
//                                   showDialog(
//                                     context: context,
//                                     builder: (_) {
//                                       return AlertDialog(
//                                         title:
//                                             Text("Refund/Cancellation Policy"),
//                                         content: Text(
//                                             "Course fee once paid will not be refunded. Are you sure to cancel the booking?"),
//                                         actions: <Widget>[
//                                           // ボタン領域
//                                           FlatButton(
//                                             child: Text("Cancel"),
//                                             onPressed: () =>
//                                                 Navigator.pop(context),
//                                           ),
//                                           FlatButton(
//                                             child: Text("OK"),
//                                             onPressed: () => {
//                                               updateSessionDetails(),
//                                               Navigator.pop(context),
//                                             },
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   );
//                                 },
//                                 textColor: Colors.white,
//                                 padding: const EdgeInsets.all(0),
//                                 child: Container(
//                                   width: double.infinity,
// //                                                      width: MediaQuery.of(context).size.width * 0.45,
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: <Color>[
//                                         Colors.pink[300],
//                                         Colors.purple[500],
//                                         Colors.purple[700],
//                                       ],
//                                     ),
//                                   ),
//                                   child: const Text('Cancel',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 30,
//                                       )),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )));
//               } else if (snapshot.connectionState != ConnectionState.done) {
//                 return Center(child: CircularProgressIndicator());
//               } else {
//                 return Text("データが存在しません");
//               }
//             }));
//   }

//   Future<http.Response> updateSessionDetails() {
//     print("updateSessionDetails called");
//     String url =
//         "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions/" +
//             widget.sessionID;
//     final dynamic result = http.put(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, dynamic>{
//         'user_username': "",
//       }),
//     );

//     if (result.statusCode == 201) {
//       print("cancel successful");
//       Navigator.pop(context, false);
//       return result;
//     } else {
//       print("cancel unsuccesful");
//     }
//     return null;
//   }
// }
