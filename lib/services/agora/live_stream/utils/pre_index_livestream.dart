import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: unused_import
import 'package:skilltrain/main_app/trainer/pages/instructor_view/instructor_view.dart';

import 'dart:async';

// *********** 1to1 VC Mode *********** //

class IndexPageBroadcast extends StatefulWidget {
  final instructorName;
  IndexPageBroadcast({this.instructorName});

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPageBroadcast> {
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
              Column(
                children: <Widget>[
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
                            onPressed: () {},
                            child: Text('Create a room'),
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
                            onPressed: () => {},
                            child: Text('Join a room'),
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
}

// *********** 1to1 VC Mode *********** //
