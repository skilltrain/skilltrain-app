import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class AWSRealtimeSocketTutorialChatPage extends StatefulWidget {
  AWSRealtimeSocketTutorialChatPage({
    @required this.socketChannel,
    this.userName,
  });
  final String userName;
  final WebSocketChannel socketChannel;

  @override
  _AWSRealtimeSocketTutorialChatPageState createState() =>
      _AWSRealtimeSocketTutorialChatPageState();
}

class _AWSRealtimeSocketTutorialChatPageState
    extends State<AWSRealtimeSocketTutorialChatPage> {
  TextEditingController msgController = TextEditingController(text: '');
  ScrollController scrollController = new ScrollController();

  String socketData;
  Map connectionData; // {"fromLogin":true,"connectionID":"VuDNxcaAIAMCIoQ=","connectedAt":1604891224037,"ipAddress":"108.162.151.86","userName":"Taehoon"}
  List messages;

  @override
  void initState() {
    // Start listening socket stream
    widget.socketChannel.stream.listen((message) {
      print('Message from stream listen: $message');
      setState(() => socketData = message);
    });
    super.initState();
  }
  // @override
  // void initState() {
  //   // Start listening socket stream
  //   widget.socketChannel.stream.listen(
  //     (message) {
  //       print('Message from stream listen: $message');
  //       Map tempMessageParser = jsonDecode(message);

  //       // Result from ping
  //       bool fromPing = false;
  //       if (tempMessageParser.containsKey('fromLogin') &&
  //           tempMessageParser['fromLogin']) {
  //         // connection handler
  //         fromPing = true;
  //         _getMessages();
  //       } else {
  //         // Message handler
  //         // {fromLogin: false, connectionID: connectionId, messageData: messageData}
  //         /*
  //           sample messageData ==>
  //           {
  //             'created': record.dynamodb.NewImage['data']['M']['created'],
  //             'ipAddress': record.dynamodb.NewImage['data']['M']['ipAddress'],
  //             'id': record.dynamodb.NewImage['data']['M']['id'],
  //             'userName': record.dynamodb.NewImage['data']['M']['userName'],
  //             'content': record.dynamodb.NewImage['data']['M']['content'],
  //           };
  //         */
  //         //print('Message received: ${tempMessageParser['messageData']}');
  //         _getMessages();
  //       }
  //       // setState(() {
  //       //   socketData = message;
  //       //   if (fromPing) connectionData = tempMessageParser;
  //       // }); // display WHATEVER data received
  //     },
  //     onError: (e) {
  //       print('Error listening: ${e.toString()}');
  //       // Maybe disconnected or server not working. Go back.
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text("Disconnected"),
  //             content: Text(
  //                 "You are disconnected from the chat room. Going back..."),
  //             actions: [
  //               FlatButton(
  //                 child: Text("OK"),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //     cancelOnError: true,
  //   );

  //   _login(); // Ping to get connection info

  //   super.initState();
  // }

  @override
  void dispose() {
    // Make sure to close the stream when its not in use
    widget.socketChannel.sink.close();
    super.dispose();
  }

  void _login() async {
    widget.socketChannel.sink.add(jsonEncode({
      "action": "chatRoomLogin",
      "userName": widget.userName ?? 'John Doe',
    }));
    print('login requested.....${widget.userName}');
  }

  /// Get all messages
  Future _getMessages() async {
    try {
      var data = await http.get(
          'https://3hb0estmxk.execute-api.us-east-1.amazonaws.com/dev/flutter-aws-serverless/messages/getMessage');

      Map decodedData = jsonDecode(data.body);
      //print('Data is $decodedData');
      if (decodedData['result']['statusCode'] == 200) {
        // sort - Better to be handled in lambda and dynamoDB config
        List _dataList = decodedData['result']['body'];
        _dataList.sort(
            (a, b) => a['data']['created'] > b['data']['created'] ? 1 : 0);

        setState(() {
          messages = _dataList ?? [];
        });

        // Scroll to botom
        Timer(
          Duration(milliseconds: 300),
          () => scrollController
              .jumpTo(scrollController.position.maxScrollExtent),
        );
      }
    } catch (e) {}
  }

  void sendMessage() async {
    // Grab text and send out

    if (connectionData != null && msgController.text.isNotEmpty) {
      print('Sending text: ${msgController.text} ==> $connectionData');
      try {
        var data = await http.post(
          'https://3hb0estmxk.execute-api.us-east-1.amazonaws.com/dev/flutter-aws-serverless/messages/createMessageUser',
          body: jsonEncode({
            'ipAddress': connectionData['ipAddress'],
            'content': msgController.text,
            'userName': connectionData['userName'],
          }),
          headers: {'Content-type': 'application/json'}, // IMPORTANT!
        );
        Map decodedData = jsonDecode(data.body);
        print('Message Sent! $decodedData');

        // clear text field
        setState(() {
          msgController.clear();
        });
      } catch (e) {}
    }
  }

  void _onWriteThroughSocket() async {
    // Generate a random number
    var rng = new Random();
    int generatedInt = rng.nextInt(10000);
    // Write through lambda function & API Gateway
    widget.socketChannel.sink.add(jsonEncode({
      "action": "chatTest",
      "randNum": generatedInt,
      "msg": "tester from $generatedInt"
    }));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 500,
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // List of messages here
                    _chatMessage(screenSize),
                    SizedBox(
                      height: 25,
                    ),
                    _charInput(),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      child: FlatButton(
                        onPressed: _onWriteThroughSocket,
                        child: Text('Post to socket'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side:
                              BorderSide(color: Theme.of(context).buttonColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatMessage(Size screenSize) {
    // If message from me, align right, otherwiase align left
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: messages != null ? messages.length : 0,
        itemBuilder: (context, index) {
          Map item = messages[index];

          AlignmentGeometry _alignDirection =
              item['data']['ipAddress'] == connectionData['ipAddress']
                  ? Alignment.centerRight
                  : Alignment.centerLeft;
          return Container(
            alignment: _alignDirection,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: SizedBox(
              width: 120 + screenSize.width * 0.4,
              child: Card(
                color: Colors.grey.shade300,
                elevation: 5.0,
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 32,
                  ),
                  title: Text(
                    item['data']['content'],
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    '${item['data']['userName']} (${item['data']['ipAddress']})',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _charInput() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: msgController,
                  decoration: InputDecoration(
                    hintText: "Type messages here...",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: sendMessage,
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 50.0),
            child: Text(
              connectionData != null
                  ? '${widget.userName} (${connectionData['ipAddress']}) (${connectionData['connectionID']})'
                  : '',
              style: TextStyle(
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
