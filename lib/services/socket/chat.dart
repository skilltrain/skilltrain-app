import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AWSRealtimeSocketTutorialPage extends StatefulWidget {
  AWSRealtimeSocketTutorialPage({@required this.socketChannel});
  final WebSocketChannel socketChannel;
  @override
  _AWSRealtimeSocketTutorialPageState createState() =>
      _AWSRealtimeSocketTutorialPageState();
}

class _AWSRealtimeSocketTutorialPageState
    extends State<AWSRealtimeSocketTutorialPage> {
  String socketData;
  @override
  void initState() {
    // Start listening socket stream
    widget.socketChannel.stream.listen((message) {
      print('Message from stream listen: $message');
      setState(() => socketData = message);
    });
    super.initState();
  }

  @override
  void dispose() {
    // Make sure to close the stream when its not in use
    widget.socketChannel.sink.close();
    super.dispose();
  }

  void _onWriteThroughSocket() async {
    // Generate a random number
    var rng = new Random();
    int generatedInt = rng.nextInt(10000);
    // Write through lambda function & API Gateway
    widget.socketChannel.sink.add(jsonEncode({
      "action": "databaseStream",
      "data": {
        "body": {"randNum": generatedInt, "msg": "tester from $generatedInt"}
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    // var screenSize = MediaQuery.of(context).size;
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: FlatButton(
              onPressed: _onWriteThroughSocket,
              child: Text(
                'Write to DynamoDB',
                style: themeData.primaryTextTheme.button,
              ),
              color: themeData.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Theme.of(context).buttonColor),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
              child: Text(socketData != null ? '$socketData' : 'Empty'),
            ),
          )
        ],
      ),
    );
  }
}
