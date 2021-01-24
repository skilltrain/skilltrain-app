import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
<<<<<<< HEAD
import 'package:skilltrain/main_app/common/headings.dart';
import 'package:skilltrain/services/agora/video_session/index_trainee.dart';
import 'package:skilltrain/utils/sliders.dart';
=======
>>>>>>> a70344867f02019fc58e9bc7cdb2da36d56f160e
import 'package:web_socket_channel/io.dart';
import '../../../utils/bubble.dart';

class TraineeSessionDetailsPage extends StatefulWidget {
  final String sessionID;
  final String trainer;
  final String startTime;
  final String endTime;
  final String date;
  final String description;
  final String sessionCode;
  final socketChannel = IOWebSocketChannel.connect(
      'wss://e5q5rdsxf5.execute-api.ap-northeast-1.amazonaws.com/dev/');

  TraineeSessionDetailsPage({
    @required this.sessionID,
    this.trainer,
    this.startTime,
    this.endTime,
    this.date,
    this.description,
    this.sessionCode,
  });
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
    DateTime newDate = DateTime.parse(widget.date);
    var format = new DateFormat("MMMEd");
    var dateString = format.format(newDate);
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Color(0xFFFFFFFF),
            bottom: TabBar(
              indicatorColor: Colors.cyanAccent,
              tabs: [
                Tab(
                    icon: Icon(
                  Icons.info_outline,
                  color: Colors.black,
                )),
                Tab(
                    icon: Icon(
                  Icons.chat,
                  color: Colors.black,
                )),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //THIS IS THE DETAILS PAGE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.all(36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          blackHeading(
                              title: "Your Session",
                              underline: false,
                              purple: false),
                          blackHeading(
                              title: "with " + widget.trainer,
                              underline: true,
                              purple: false)
                        ],
                      )),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 36, vertical: 36),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                        color: Colors.purple,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Session with",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              Text(dateString,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.trainer,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                                Text(widget.startTime + "-" + widget.endTime,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 36.0),
                            child: Text(
                              widget.description.length > 2
                                  ? widget.description
                                  : "This trainer has not added any details about this session.",
                              maxLines: 3,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(36.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    primary: Colors.cyanAccent, // background
                                    onPrimary: Colors.white, // foreground
                                  ),
                                  onPressed: () => {
                                        Navigator.push(
                                            context,
                                            SlideLeftRoute(
                                                page: IndexPageTrainee(
                                                    sessionCode:
                                                        widget.sessionCode)))
                                      },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.video_call),
                                      Text("  Start Your Session Now",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  )))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
