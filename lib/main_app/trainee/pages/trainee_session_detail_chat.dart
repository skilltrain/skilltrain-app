import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
import '../../../utils/bubble.dart';

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
  var messages = [];
  final _messageController = TextEditingController();

  @override
  void initState() {
    // Start listening socket stream
    widget.socketChannel.stream.listen((message) {
      print('Message from stream listen: $message');
      _getMessages(widget.sessionID);
    });
    //The cloud function is set to update only the connectionID if the user sends through
    //an empty message, so, this can happen when the user first opens this page
    //note that the connectionID will change every single time line 26 is run, therefore
    //the connectionID must be updated everytime they open this page
    //if the user personally sends through an empty string, no harm will be done as the
    //connectionID will only update
    _onWriteThroughSocket(' ');
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
    var now = new DateTime.now();
    final DateFormat formatter = new DateFormat('MMM-dd hh:mm aa');
    final String formattedNow = formatter.format(now).toString();
    print(formattedNow);
    final messageObject = {
      "action": "writeMessage",
      "data": {
        "body": {
          "msg": message,
          "sessionID": widget.sessionID,
          "isTrainer": false,
          "time": formattedNow
        }
      }
    };
    // ' ' is for initial message to enter id into table, however if it isn't ' ',
    // then we can update the local screen with setState, will not receive a response
    // from the stream as it is not necessary, will not do any server calls
    if (message != ' ') {
      messages.add({
        'msg': message,
        'sessionID': widget.sessionID,
        'isTrainer': false,
        'time': formattedNow
      });
      setState(() {
        messages = messages;
      });
    }
    widget.socketChannel.sink.add(jsonEncode(messageObject));
  }

  void _getMessages(String sessionID) async {
    final data = await http.get(
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/sessions/messages?sessionID=$sessionID');
    final decodedData = await json.decode(data.body);
    setState(() {
      if (decodedData.length > 0) {
        messages = decodedData["messages"];
      } else {
        messages = [];
      }
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
                              return new Bubble(
                                message: messages[index]['msg'],
                                time: messages[index]['time'],
                                isMe: messages[index][
                                    'isTrainer'], // This is wrong on purpose, right side for self looks better
                                delivered: true,
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
                          onPressed: () {
                            _onWriteThroughSocket(_messageController.text);
                            _messageController.clear();
                          }),
                    ],
                  )
                ],
              )
            ],
          )),
    ));
  }
}
