import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../booking_status.dart';
import '../home_page.dart';

import 'dart:async';
import './call.dart';
import './utils/settings.dart';

// *********** 1-to-1 VC session *********** //

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new IndexState();
  }
}

class IndexState extends State<IndexPage> {
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






