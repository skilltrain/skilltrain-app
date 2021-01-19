import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: unused_import
import 'package:skilltrain/main_app/trainer/pages/instructor_view/instructor_view.dart';

import 'dart:async';
import 'call_trainee.dart';

// *********** 1to1 VC Mode *********** //

class IndexPageTrainee extends StatefulWidget {
  final instructorName;
  IndexPageTrainee({this.instructorName});

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPageTrainee> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;

  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('SkillTrain-Session'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 333,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Text('Join as : Trainee',
                      style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.purple)),
                ),
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        controller: _channelController,
                        decoration: InputDecoration(
                          errorText: _validateError
                              ? 'Channel name is mandatory'
                              : null,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                          hintText: 'Channel name',
                        ),
                      ))
                    ],
                  ),
                  Column(
                    children: [
                      // ListTile(
                      //   title: Text(ClientRole.Broadcaster.toString()),
                      //   leading: Radio(
                      //     value: ClientRole.Broadcaster,
                      //     groupValue: _role,
                      //     onChanged: (ClientRole value) {
                      //       setState(() {
                      //         _role = value;
                      //       });
                      //     },
                      //   ),
                      // ),
                      // ListTile(
                      //   title: Text(ClientRole.Audience.toString()),
                      //   leading: Radio(
                      //     value: ClientRole.Audience,
                      //     groupValue: _role,
                      //     onChanged: (ClientRole value) {
                      //       setState(() {
                      //         _role = value;
                      //       });
                      //     },
                      //   ),
                      // )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              onJoin();
                            },
                            child: Text('Join'),
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
                              Navigator.pop(context),
                              Navigator.pop(context),
                              // Navigator.push(context,
                              //     SlideLeftRoute(page: HomePageTrainee()))
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
              channelName: _channelController.text,
              role: _role,
              instructorName: widget.instructorName),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}

// *********** 1to1 VC Mode *********** //
