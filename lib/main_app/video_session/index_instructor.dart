import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../booking_status.dart';
import '../home_page.dart';

import 'dart:async';
import './call.dart';
import './utils/settings.dart';

// *********** 1-to-1 VC session *********** //

class IndexPageForInstructor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new IndexState();
  }
}

class IndexState extends State<IndexPageForInstructor> {
  final _channelController = TextEditingController();

  bool _validateError = false;
  bool _video = true;
  bool _audio = true;
  bool _screen = false;
  String _profile = "480p";
  final String _appId = appId;

  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _frameRateController = TextEditingController();

  String _codec = "h264";
  String _mode = "live";

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _frameRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('SkillTrain-Session'),
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 400,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        "Agora",
                        style: TextStyle(
                          fontSize: 74.0,
                          fontWeight: FontWeight.w900,
                          // fontFamily: "Georgia",
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    TextField(
                      controller: _channelController,
                      decoration: InputDecoration(
                          errorText: _validateError
                              ? "Channel name is mandatory"
                              : null,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'Channel name'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () => onJoin(),
                              child: Text("Join"),
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () => {
                                Navigator.push(
                                    context, SlideLeftRoute(page: HomePage()))
                              },
                              child: Icon(Icons.home),
                              color: Colors.grey,
                              textColor: Colors.white,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            // CheckboxListTile()
                          ],
                        ),
                      ),
                      Expanded(
                          child: Column(children: <Widget>[
                        // RadioListTile()
                      ])),
                    ],
                  ),
                ),
              ],
            )),
      ),
      // drawer: Drawer()
    );
  }

  onJoin() {
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });

    if (_channelController.text.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new CallPage(
                    appId: _appId,
                    channel: _channelController.text,
                    video: _video,
                    audio: _audio,
                    screen: _screen,
                    profile: _profile,
                    width: _widthController.text,
                    height: _heightController.text,
                    framerate: _frameRateController.text,
                    codec: _codec,
                    mode: _mode,
                  )));
    }
  }
}


// *********** 1-to-1 VC session *********** //















// *********** BroadCasting function *********** //

// class IndexPageForInstructor extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => IndexState();
// }

// class IndexState extends State<IndexPageForInstructor> {
//   /// create a channelController to retrieve text value
//   final _channelController = TextEditingController();

//   /// if channel textField is validated to have error
//   bool _validateError = false;

//   ClientRole _role = ClientRole.Audience;

//   @override
//   void dispose() {
//     // dispose input controller
//     _channelController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: new IconButton(
//           icon: new Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text('SkillTrain-Session'),
//       ),
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           height: 400,
//           child: Column(
//             children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   Expanded(
//                       child: TextField(
//                     controller: _channelController,
//                     decoration: InputDecoration(
//                       errorText:
//                           _validateError ? 'Channel name is mandatory' : null,
//                       border: UnderlineInputBorder(
//                         borderSide: BorderSide(width: 1),
//                       ),
//                       hintText: 'Channel name',
//                     ),
//                   ))
//                 ],
//               ),
//               Column(
//                 children: [
//                   ListTile(
//                     title: Text(ClientRole.Broadcaster.toString()),
//                     leading: Radio(
//                       value: ClientRole.Broadcaster,
//                       groupValue: _role,
//                       onChanged: (ClientRole value) {
//                         setState(() {
//                           _role = value;
//                         });
//                       },
//                     ),
//                   ),
//                   ListTile(
//                     title: Text(ClientRole.Audience.toString()),
//                     leading: Radio(
//                       value: ClientRole.Audience,
//                       groupValue: _role,
//                       onChanged: (ClientRole value) {
//                         setState(() {
//                           _role = value;
//                         });
//                       },
//                     ),
//                   )
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: RaisedButton(
//                         onPressed: onJoin,
//                         child: Text('Join'),
//                         color: Colors.blueAccent,
//                         textColor: Colors.white,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: RaisedButton(
//                         onPressed: () => {
//                           Navigator.push(
//                               context, SlideLeftRoute(page: HomePage()))
//                         },
//                         child: Icon(Icons.home),
//                         color: Colors.grey,
//                         textColor: Colors.white,
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> onJoin() async {
//     // update input validation
//     setState(() {
//       _channelController.text.isEmpty
//           ? _validateError = true
//           : _validateError = false;
//     });
//     if (_channelController.text.isNotEmpty) {
//       // await for camera and mic permissions before pushing video page
//       await _handleCameraAndMic(Permission.camera);
//       await _handleCameraAndMic(Permission.microphone);
//       // push video page with given channel name
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CallPage(
//             channelName: _channelController.text,
//             role: _role,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> _handleCameraAndMic(Permission permission) async {
//     final status = await permission.request();
//     print(status);
//   }
// }

// *********** BroadCasting function *********** //