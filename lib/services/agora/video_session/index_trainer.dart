import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skilltrain/main_app/common/buttons.dart';
import 'package:skilltrain/main_app/common/headings.dart';

import 'dart:async';
import 'call_trainer.dart';

// *********** 1to1 VC Mode *********** //

class IndexPageTrainer extends StatefulWidget {
  final String sessionCode;

  IndexPageTrainer({this.sessionCode});

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPageTrainer> {
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
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/icon/icon.png',
          height: 36.0,
          width: 36.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 36),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        blackHeading(
                            title: "Are you", underline: false, purple: false),
                        blackHeading(
                            title: "READY?", underline: true, purple: true),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Text(
                              "Enter the channel name below to start your video session with your trainee!",
                              style: TextStyle(fontSize: 25)),
                        ),
                      ],
                    ),
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
                            hintText: "Session Code",
                            helperText:
                                "Your session code is : " + widget.sessionCode,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          cyanButton(
                            text: "Join Session",
                            function: () {
                              onJoin();
                            },
                          )
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 20),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Expanded(
                    //         child: RaisedButton(
                    //           onPressed: onJoin,
                    //           child: Text('Join'),
                    //           color: Colors.blueAccent,
                    //           textColor: Colors.white,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
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
          ),
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
