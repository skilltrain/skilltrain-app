import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:agora_flutter_webrtc/agora_flutter_webrtc.dart';

import './utils/settings.dart';

// *********** 1-to-1 VC session *********** //

class CallPage extends StatefulWidget {
  final String channel;
  final bool video;
  final bool audio;
  final bool screen;
  final String appId;
  final String profile;
  final String width;
  final String height;
  final String framerate;
  final String codec;
  final String mode;

  CallPage({
    this.appId,
    this.channel,
    this.video,
    this.audio,
    this.screen,
    this.profile,
    this.width,
    this.height,
    this.framerate,
    this.codec,
    this.mode,
  });

  @override
  CallPageState createState() {
    return new CallPageState(
      appId: appId,
      channel: channel,
      video: video,
      audio: audio,
      screen: screen,
      profile: profile,
      width: width,
      height: height,
      framerate: framerate,
      codec: codec,
      mode: mode,
    );
  }
}

class CallPageState extends State<CallPage> {
  String appId;
  String channel;
  bool video;
  bool audio;
  bool screen;
  String profile;
  String width;
  String height;
  String framerate;
  String codec;
  String mode;

  AgoraClient agoraClient;
  AgoraClient shareScreenClient;

  AgoraStream mainStream;
  AgoraStream shareScreenStream;

  List<AgoraStream> remoteStreams;
  List<AgoraStream> localStreams;
  List<AgoraStream> allStreams;
  List<Timer> timers = new List<Timer>();

  Map<String, String> mediaStats;

  CallPageState({
    this.appId,
    this.channel,
    this.video,
    this.audio,
    this.screen,
    this.profile,
    this.width,
    this.height,
    this.framerate,
    this.codec,
    this.mode,
  });

  void startShareScreen(String cname) async {
    shareScreenClient = AgoraClient(appId: appId, mode: mode, codec: codec);

    await shareScreenClient.join(null, cname, 1);
    shareScreenStream = AgoraStream.createStream(
        {'audio': false, 'video': false, 'screen': true});

    try {
      await shareScreenStream.init();
    } catch (e) {}

    await shareScreenClient.publish(shareScreenStream);
    localStreams.add(shareScreenStream);
  }

  void stopShareScreen() async {
    await shareScreenClient?.leave();
    shareScreenClient = null;
    shareScreenStream?.close();
  }

  void initState() {
    super.initState();

    print(
        "$channel,$video,$audio,$screen,$profile,$width,$height,$framerate,$codec,$mode");

    localStreams = new List<AgoraStream>();
    remoteStreams = new List<AgoraStream>();
    allStreams = new List<AgoraStream>();

    agoraClient = AgoraClient(appId: appId, mode: mode, codec: codec);

    agoraClient.on("peer-leave", (evt) async {
      var uid = evt["uid"];
      var stream = remoteStreams.firstWhere((AgoraStream stream) {
        return stream.getId() == uid;
      }, orElse: () {});

      if (stream == null) {
        return;
      }
      setState(() {
        remoteStreams.remove(stream);
        allStreams.remove(stream);
      });
    });

    agoraClient.on("connection-state-change", (evt) async {
      print("state change from ${evt['prvState']} to ${evt['curState']}");
    });

    agoraClient.on("stream-removed", (evt) async {
      var stream = evt["stream"];
      setState(() {
        remoteStreams.remove(stream);
        allStreams.remove(stream);
      });
    });

    agoraClient.on("stream-added", (evt) async {
      var stream = evt["stream"];
      await agoraClient.subscribe(stream);
      remoteStreams.add(stream);
      // id=1 means this stream is sharing screen stream
      if (stream.getId() == 1) {
        await stream.play(mode: "contain");
      } else {
        await stream.play();
      }
      setState(() {
        allStreams.add(stream);
      });
    });

    agoraClient.join(null, channel, 0).then((uid) async {
      AgoraStream stream = AgoraStream.createStream(
          {'audio': audio, 'video': video, 'screen': screen});

      if (width != "" && height != "" && framerate != "") {
        stream.setVideoResolution(int.parse(width), int.parse(height));
        stream.setVideoFrameRate(int.parse(framerate));
      } else {
        stream.setVideoProfile(profile);
      }

      await stream.init();
      localStreams.add(stream);
      await stream.play();
      setState(() {
        mainStream = stream;
        allStreams.add(stream);
      });
      return stream;
    }).then((stream) async {
      await agoraClient.publish(stream);
    });
    var timer = Timer.periodic(new Duration(seconds: 1), (_) {
      setState(() {
        mediaStats = mainStream?.getStats();
      });
    });
    timers.add(timer);
  }

  void dispose() {
    super.dispose();
    localStreams?.forEach((AgoraStream stream) {
      stream?.close();
    });
    remoteStreams?.forEach((AgoraStream stream) {
      stream?.close();
    });
    allStreams?.forEach((AgoraStream stream) {
      stream?.close();
    });
    timers?.forEach((Timer timer) {
      timer.cancel();
    });

    localStreams = [];
    remoteStreams = [];
    allStreams = [];
    timers = [];

    stopShareScreen();
    agoraClient.leave();
    agoraClient = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('In Call'),
        // ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: (mainStream != null && mainStream.isPlaying())
                        ? AgoraVideoView(mainStream)
                        : null,
                    decoration: BoxDecoration(color: Colors.black54),
                  );
                }),
                left: 0,
                top: 0,
              ),
              Positioned(
                child: ListView.builder(
                    itemCount: allStreams.length,
                    itemBuilder: (BuildContext context, int index) {
                      return (mainStream != null &&
                              allStreams[index].getId() != mainStream.getId())
                          ? Container(
                              padding: EdgeInsets.only(bottom: 12.0),
                              height:
                                  MediaQuery.of(context).size.width * 0.3 * 1.3,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    mainStream = allStreams[index];
                                  });
                                },
                                child: Container(
                                    // child: (allStreams[index] != null && allStreams[index].isPlaying()) ? RTCVideoView(allStreams[index].render) : null,
                                    child: Stack(children: <Widget>[
                                      Container(
                                          child: (allStreams[index] != null &&
                                                  allStreams[index].isPlaying())
                                              ? AgoraVideoView(
                                                  allStreams[index])
                                              : null),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          allStreams[index].getId().toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ]),
                                    decoration:
                                        BoxDecoration(color: Colors.black12)),
                              ))
                          : Container();
                    }),
                right: 16.0,
                top: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.9,
              ),
              Positioned(
                child: mainStream != null
                    ? Column(
                        children: <Widget>[
                          mainStream.isLocal == true
                              ? IconButton(
                                  icon: Icon(Icons.switch_camera,
                                      color: Colors.white),
                                  tooltip: "switch camera",
                                  onPressed: () {
                                    mainStream.switchDevice();
                                  },
                                )
                              : Container(),
                          // IconButton(
                          //   icon: shareScreenStream == null
                          //       ? Icon(Icons.screen_share, color: Colors.white)
                          //       : Icon(Icons.stop_screen_share,
                          //           color: Colors.white),
                          //   tooltip: shareScreenStream == null
                          //       ? 'start sharing screen'
                          //       : 'stop sharing screen',
                          //   onPressed: () {
                          //     if (shareScreenStream == null) {
                          //       startShareScreen(channel);
                          //     } else {
                          //       stopShareScreen();
                          //       setState(() {
                          //         shareScreenStream = null;
                          //       });
                          //     }
                          //   },
                          // ),
                          IconButton(
                            icon: mainStream.isAudioMuted
                                ? Icon(Icons.volume_off, color: Colors.white)
                                : Icon(Icons.volume_up, color: Colors.white),
                            tooltip: mainStream.isAudioMuted
                                ? 'unmute audio'
                                : 'mute audio',
                            onPressed: () {
                              if (mainStream.isAudioMuted) {
                                setState(() {
                                  mainStream.unmuteAudio();
                                });
                              } else {
                                setState(() {
                                  mainStream.muteAudio();
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: mainStream.isVideoMuted
                                ? Icon(Icons.videocam_off, color: Colors.white)
                                : Icon(Icons.videocam, color: Colors.white),
                            tooltip: mainStream.isVideoMuted
                                ? 'unmute video'
                                : 'mute video',
                            onPressed: () {
                              if (mainStream.isVideoMuted) {
                                setState(() {
                                  mainStream.unmuteVideo();
                                });
                              } else {
                                setState(() {
                                  mainStream.muteVideo();
                                });
                              }
                            },
                          ),
                        ],
                      )
                    : Container(),
                left: 0,
                bottom: 0,
              ),
              Positioned(
                child: (mainStream != null && mediaStats != null)
                    ? ListView.builder(
                        itemCount: mediaStats.length,
                        itemBuilder: (BuildContext context, int index) {
                          var key = mediaStats.keys.elementAt(index);
                          var value = mediaStats[key];
                          return Text("$key: $value",
                              style: TextStyle(color: Colors.white));
                        })
                    : Container(),
                left: 0,
                top: 0,
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.5,
              )
            ],
          ),
        ),
        endDrawer: Drawer(
          child: Container(
              child: ListView.builder(
                  itemCount: remoteStreams.length,
                  itemBuilder: (BuildContext context, int index) {
                    var stream = remoteStreams[index];
                    return Container(
                        child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(stream.getId().toString()),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: stream.isAudioMuted
                                    ? Icon(Icons.volume_off)
                                    : Icon(Icons.volume_up),
                                tooltip: stream.isAudioMuted
                                    ? 'unmute audio'
                                    : 'mute audio',
                                onPressed: () {
                                  if (stream.isAudioMuted) {
                                    setState(() {
                                      stream.unmuteAudio();
                                    });
                                  } else {
                                    setState(() {
                                      stream.muteAudio();
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: stream.isVideoMuted
                                    ? Icon(Icons.videocam_off)
                                    : Icon(Icons.videocam),
                                tooltip: stream.isVideoMuted
                                    ? 'unmute video'
                                    : 'mute video',
                                onPressed: () {
                                  print(stream.getId());
                                  if (stream.isVideoMuted) {
                                    setState(() {
                                      stream.unmuteVideo();
                                    });
                                  } else {
                                    setState(() {
                                      stream.muteVideo();
                                    });
                                  }
                                },
                              ),
                              FlatButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                onPressed: () async {
                                  if (stream.hasSubscribed) {
                                    await agoraClient.unsubscribe(stream);
                                    setState(() {
                                      allStreams.remove(stream);
                                    });
                                  } else {
                                    await agoraClient.subscribe(stream);
                                    if (stream.getId() == 1) {
                                      await stream.play(mode: "contain");
                                    } else {
                                      await stream.play();
                                    }
                                    setState(() {
                                      allStreams.add(stream);
                                    });
                                  }
                                },
                                child: Text(
                                  stream.hasSubscribed ? "unsub" : "sub",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ));
                  })),
        ));
  }
}

// *********** 1-to-1 VC session *********** //












// *********** BroadCasting Mode *********** //

// class CallPage extends StatefulWidget {
//   /// non-modifiable channel name of the page
//   final String channelName;

//   /// non-modifiable client role of the page
//   final ClientRole role;

//   /// Creates a call page with given channel name.
//   const CallPage({Key key, this.channelName, this.role}) : super(key: key);

//   @override
//   _CallPageState createState() => _CallPageState();
// }

// class _CallPageState extends State<CallPage> {
//   final _users = <int>[];
//   final _infoStrings = <String>[];
//   bool muted = false;
//   RtcEngine _engine;

//   @override
//   void dispose() {
//     // clear users
//     _users.clear();
//     // destroy sdk
//     _engine.leaveChannel();
//     _engine.destroy();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // initialize agora sdk
//     initialize();
//   }

//   Future<void> initialize() async {
//     if (appId.isEmpty) {
//       setState(() {
//         _infoStrings.add(
//           'APP_ID missing, please provide your APP_ID in settings.dart',
//         );
//         _infoStrings.add('Agora Engine is not starting');
//       });
//       return;
//     }

//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     await _engine.enableWebSdkInteroperability(true);
//     VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
//     configuration.dimensions = VideoDimensions(1920, 1080);
//     await _engine.setVideoEncoderConfiguration(configuration);
//     await _engine.joinChannel(null, widget.channelName, null, 0);
//   }

//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     _engine = await RtcEngine.create(appId);
//     await _engine.enableVideo();
//     await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await _engine.setClientRole(widget.role);
//   }

//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
//       setState(() {
//         final info = 'onError: $code';
//         _infoStrings.add(info);
//       });
//     }, joinChannelSuccess: (channel, uid, elapsed) {
//       setState(() {
//         final info = 'onJoinChannel: $channel, uid: $uid';
//         _infoStrings.add(info);
//       });
//     }, leaveChannel: (stats) {
//       setState(() {
//         _infoStrings.add('onLeaveChannel');
//         _users.clear();
//       });
//     }, userJoined: (uid, elapsed) {
//       setState(() {
//         final info = 'userJoined: $uid';
//         _infoStrings.add(info);
//         _users.add(uid);
//       });
//     }, userOffline: (uid, elapsed) {
//       setState(() {
//         final info = 'userOffline: $uid';
//         _infoStrings.add(info);
//         _users.remove(uid);
//       });
//     }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
//       setState(() {
//         final info = 'firstRemoteVideo: $uid ${width}x $height';
//         _infoStrings.add(info);
//       });
//     }));
//   }

//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     final List<StatefulWidget> list = [];
//     if (widget.role == ClientRole.Broadcaster) {
//       list.add(RtcLocalView.SurfaceView());
//     }
//     _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
//     return list;
//   }

//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }

//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }

//   /// Video layout wrapper
//   Widget _viewRows() {
//     final views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//           children: <Widget>[_videoView(views[0])],
//         ));
//       case 2:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow([views[0]]),
//             _expandedVideoRow([views[1]])
//           ],
//         ));
//       case 3:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 3))
//           ],
//         ));
//       case 4:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 4))
//           ],
//         ));
//       default:
//     }
//     return Container();
//   }

//   /// Toolbar layout
//   Widget _toolbar() {
//     if (widget.role == ClientRole.Audience) return Container();
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           RawMaterialButton(
//             onPressed: _onToggleMute,
//             child: Icon(
//               muted ? Icons.mic_off : Icons.mic,
//               color: muted ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: muted ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           ),
//           RawMaterialButton(
//             onPressed: () => _onCallEnd(context),
//             child: Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15.0),
//           ),
//           RawMaterialButton(
//             onPressed: _onSwitchCamera,
//             child: Icon(
//               Icons.switch_camera,
//               color: Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           )
//         ],
//       ),
//     );
//   }

//   /// Info panel to show logs
//   Widget _panel() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       alignment: Alignment.bottomCenter,
//       child: FractionallySizedBox(
//         heightFactor: 0.5,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           child: ListView.builder(
//             reverse: true,
//             itemCount: _infoStrings.length,
//             itemBuilder: (BuildContext context, int index) {
//               if (_infoStrings.isEmpty) {
//                 return null;
//               }
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 3,
//                   horizontal: 10,
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 2,
//                           horizontal: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.yellowAccent,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Text(
//                           _infoStrings[index],
//                           style: TextStyle(color: Colors.blueGrey),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   void _onCallEnd(BuildContext context) {
//     Navigator.pop(context);
//   }

//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     _engine.muteLocalAudioStream(muted);
//   }

//   void _onSwitchCamera() {
//     _engine.switchCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SkillTrain-Session'),
//       ),
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Stack(
//           children: <Widget>[
//             _viewRows(),
//             _panel(),
//             _toolbar(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// *********** BroadCasting Mode *********** //