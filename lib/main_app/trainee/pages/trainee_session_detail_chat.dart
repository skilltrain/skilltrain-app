import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';

//Eliot - I think we could use the same page for both trainer and user??
class TraineeSessionDetailsPage extends StatefulWidget {
  final String sessionID;
  final socketChannel = IOWebSocketChannel.connect(
      'wss://e5q5rdsxf5.execute-api.ap-northeast-1.amazonaws.com/dev/');

  TraineeSessionDetailsPage({@required this.sessionID});
  @override
  _TraineeSessionDetailsPageState createState() =>
      _TraineeSessionDetailsPageState();
}

class _TraineeSessionDetailsPageState extends State<TraineeSessionDetailsPage> {
  var messages;
  final _messageController = TextEditingController();

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
    _messageController.dispose();
    super.dispose();
  }

  void _onWriteThroughSocket(String message) async {
    // Write through lambda function & API Gateway
    widget.socketChannel.sink.add(jsonEncode({
      "action": "writeMessage",
      "data": {
        "body": {
          "msg": message,
          "sessionID": widget.sessionID,
          "isTrainer": false
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
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Session Details and Chat"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.details)),
                Tab(icon: Icon(Icons.chat)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //THIS IS THE DETAILS PAGE
              Text("This will be the details page"),
              //THIS IS THE CHAT TAB
              Column(
                children: [
                  messages != null
                      ? Expanded(
                          child: Container(
                          child: ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (BuildContext context, int index) {
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
                      : Text('null'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration:
                              InputDecoration(hintText: "Type a message"),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () =>
                              {_onWriteThroughSocket(_messageController.text)}),
                    ],
                  )
                ],
              )
            ],
          )),
    ));
  }
}
