import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skilltrain/main_app/common/headings.dart';
// ignore: unused_import
import 'package:skilltrain/main_app/trainer/pages/instructor_view/instructor_view.dart';

import 'dart:async';
import 'call_audience.dart';
import 'dart:math';
import 'package:share/share.dart';

// *********** 1to1 VC Mode *********** //

String sessionCode(int length) {
  const _randomeChars = "abcdefghijklmnopqrstuvwxyz0123456789";
  const _charsLength = _randomeChars.length;

  final rand = new Random();
  final codeUnits = new List.generate(length, (index) {
    final n = rand.nextInt(_charsLength);
    return _randomeChars.codeUnitAt(n);
  });
  return new String.fromCharCodes(codeUnits);
}

class IndexPageStreamer extends StatefulWidget {
  final instructorName;
  IndexPageStreamer({this.instructorName});

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPageStreamer> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;

  /// client = broadcaster or audience
  ClientRole _role = ClientRole.Broadcaster;

  /// for session
  bool flag = false;
  String code = "";

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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 36),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        blackHeading(
                            title: "Create a ",
                            underline: false,
                            purple: false),
                        blackHeading(
                            title: "Livestream?",
                            underline: true,
                            purple: true),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Text(
                              "Create a channel by clicking the button below!",
                              style: TextStyle(fontSize: 25)),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            flag = !flag;
                            code = sessionCode(6);
                          });
                        },
                        child: flag ? Text(code) : Text("Get a token"),
                        color: flag ? Colors.white : Colors.yellow,
                        textColor: flag ? Colors.black87 : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            Share.share(
                                "Join my livestream session! Here is my Channel session code: " +
                                    code +
                                    ".");
                          })
                    ]),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      controller: _channelController,
                      decoration: InputDecoration(
                        errorText:
                            _validateError ? 'Channel name is mandatory' : null,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                        hintText: 'Channel name',
                      ),
                    ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          onJoin();
                        },
                        child: Text('Join'),
                        color: Colors.cyanAccent,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // ],
          ),
        ),
      ),
      // ),
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
