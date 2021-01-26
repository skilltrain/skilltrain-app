import 'package:flutter/material.dart';
import 'package:skilltrain/main_app/common/buttons.dart';
import 'package:skilltrain/main_app/common/headings.dart';
import 'index_streamer.dart';
import 'index_audience.dart';

// *********** 1to1 VC Mode *********** //

class IndexPageLiveStream extends StatefulWidget {
  final instructorName;
  IndexPageLiveStream({this.instructorName});

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPageLiveStream> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error

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
                            title: "Create a", underline: false, purple: false),
                        blackHeading(
                            title: "Session?", underline: true, purple: true),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      cyanButton(
                        text: "Create Session",
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return IndexPageStreamer();
                            }),
                          );
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        blackHeading(
                            title: "Join a", underline: false, purple: false),
                        blackHeading(
                            title: "Session?", underline: true, purple: false),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Join Session'),
                        color: Colors.purple,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return IndexPageAudience();
                              },
                            ),
                          )
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // body: Center(
      //   child: Container(
      //     padding: const EdgeInsets.symmetric(horizontal: 20),
      //     height: 333,
      //     child: Column(
      //       children: <Widget>[
      //         Column(
      //           children: <Widget>[
      //             Column(
      //               children: [],
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.symmetric(vertical: 20),
      //               child: Row(
      //                 children: <Widget>[
      //                   Expanded(
      //                     child: RaisedButton(
      // onPressed: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) {
      //       return IndexPageStreamer();
      //     }),
      //   );
      // },
      //                       child: Text('Create a room'),
      //                       color: Colors.blueAccent,
      //                       textColor: Colors.white,
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.symmetric(vertical: 10),
      //               child: Row(
      //                 children: <Widget>[
      //                   Expanded(
      //                     child: RaisedButton(
      // onPressed: () => {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) {
      //       return IndexPageAudience();
      //     }),
      //   )
      // },
      //                       child: Text('Join a room'),
      //                       color: Colors.grey,
      //                       textColor: Colors.white,
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             )
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

// *********** 1to1 VC Mode *********** //
