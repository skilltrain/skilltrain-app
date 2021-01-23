import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class AWSRealtimeSocketTutorialPage extends StatefulWidget {
  AWSRealtimeSocketTutorialPage(
      {@required this.socketChannel, @required this.sessionID});
  final WebSocketChannel socketChannel;
  final String sessionID;
  @override
  _AWSRealtimeSocketTutorialPageState createState() =>
      _AWSRealtimeSocketTutorialPageState();
}

class _AWSRealtimeSocketTutorialPageState
    extends State<AWSRealtimeSocketTutorialPage> {
  String socketData;
  var messages;
  @override
  void initState() {
    // Start listening socket stream
    widget.socketChannel.stream.listen((message) {
      print('Message from stream listen: $message');
      _getMessages(widget.sessionID);
    });
    _getMessages(widget.sessionID);
    super.initState();
  }

  @override
  void dispose() {
    // Make sure to close the stream when its not in use
    widget.socketChannel.sink.close();
    super.dispose();
  }

  void _onWriteThroughSocket() async {
    // Write through lambda function & API Gateway
    widget.socketChannel.sink.add(jsonEncode({
      "action": "writeMessage",
      "data": {
        "body": {
          "msg": "cyant",
          "sessionID": widget.sessionID,
          "isTrainer": true
        }
      }
    }));
  }

  void _getMessages(String sessionID) async {
    final data = await http.get(
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions/messages?sessionID=$sessionID');
    final decodedData = await json.decode(data.body);
    setState(() {
      messages = decodedData["messages"];
    });
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
          ),
          messages != null
              ? Expanded(
                  child: Container(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      // print('${messages["messages"][index]["msg"]}');
                      return new Column(
                        children: <Widget>[
                          new Text('${messages[index]["msg"]}'),
                          new Divider(
                            height: 2.0,
                          ),
                        ],
                      );
                    },
                  ),
                ))
              : Text('null')
        ],
      ),
    );
  }
}
