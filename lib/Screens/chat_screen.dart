import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/Controllers/HomeController.dart';
import 'package:q8_pulse/Widgets/AppBarWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:q8_pulse/Widgets/ChatCliper.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
//import 'package:audioplayers/audioplayers.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:q8_pulse/Widgets/ChatCliper2.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/Widgets/player_widget.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:q8_pulse/utils/app_Localization.dart';

const String defaultUserName = "John Doe";

const kUrl1 = 'http://162.244.80.118:3020/stream.mp3';

class ChatScreen extends StatefulWidget {
  String phone;
  int guestId ;

  ChatScreen({this.phone ,this.guestId});
  createState() => ChatView();
}

class ChatView extends StateMVC<ChatScreen> with TickerProviderStateMixin {
  static const platform = const MethodChannel('test_activity');

  // String _responseFromNativeCode = 'Waiting for Response...';
  // Future<void> responseFromNativeCode() async {
  //   String response = "";
  //   try {
  //     final String result = await platform.invokeMethod('helloFromNativeCode');
  //     response = result;
  //   } on PlatformException catch (e) {
  //     response = "Failed to Invoke: '${e.message}'.";
  //   }
  //   setState(() {
  //     _responseFromNativeCode = response;
  //   });
  // }
  ChatView() : super(HomeController()) {
    _homeController = HomeController.con;
  }

  HomeController _homeController;
  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _t;
  Widget _buttonIcon = Icon(
    Icons.mic,
    color: Colors.amber,
    size: 40,
  );
  String _alert;

  initState() {
    super.initState();
    _homeController.getChatList(widget.phone);
    Future.microtask(() {
      _prepare();
    });
  }

  Future _init() async {
    String customPath = '/flutter_audio_recorder_';
    io.Directory appDocDirectory;
//    if (io.Platform.isIOS) {
//      appDocDirectory = await getApplicationDocumentsDirectory();
//    } else {
//      appDocDirectory = await getExternalStorageDirectory();
//    }

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString();

    // .wav <---> AudioFormat.WAV
    // .mp4 .m4a .aac <---> AudioFormat.AAC
    // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV, sampleRate: 22050);
    await _recorder.initialized;
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        _buttonIcon = _playerIcon(_recording.status);
        _alert = "";
      });
    } else {
      setState(() {
        _alert = "Permission Required.";
      });
    }
  }

  void _opt() async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          await _startRecording();
          break;
        }
      case RecordingStatus.Recording:
        {
          await _stopRecording();

          break;
        }
      case RecordingStatus.Stopped:
        {
//          await _prepare();
          break;
        }

      default:
        break;
    }

    // 刷新按钮
    setState(() {
      _buttonIcon = _playerIcon(_recording.status);
    });
  }

  Widget _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        {
          return Icon(
            Icons.mic,
            color: Colors.amber,
            size: 40,
          );
        }
      case RecordingStatus.Recording:
        {
          return Icon(Icons.stop, color: Colors.amber, size: 40);
        }
      case RecordingStatus.Stopped:
        {
          return Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.cancel, color: Colors.amber, size: 40) ,onPressed: (){
                print("cancel");
                _prepare();
              },),
              IconButton(icon: Icon(Icons.send, color: Colors.amber, size: 40),onPressed: (){
                print("send record");
                _sendRecord();
                _prepare();


              },),

            ],
          );
        }
      default:
        return Icon(
          Icons.mic,
          color: Colors.amber,
          size: 40,
        );
    }
  }

  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
    });


  }

  Future _sendRecord() async {
    var result = await _recorder.current();
    _t.cancel();

    setState(() {
      _recording = result;
    });

    print(_recording.path);

    File recordFile = File(_recording?.path);
    print(recordFile.toString());

    _homeController.sendChatRecord(widget.phone, recordFile);
    SharedWidget.dialogRecord(context);
    _homeController.getChatList(widget.phone);
    messageController.clear();
    setState(() {
      _isWriting = false;
    });
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _play() {
   // AudioPlayer player = AudioPlayer();
   // player.play(_recording.path, isLocal: true);
  }

  Widget call() {
    return InkWell(
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/imgs/ic_call@3x.png"))),
      ),
      onTap: () {
        _homeController.onJoin(context, widget.phone , widget.guestId );
      },
    );
  }

  Widget nullWedgit() {
    return Container(
      width: 25,
      height: 25,
    );
  }

  final List<Msg> _messages = <Msg>[];
  final TextEditingController messageController = new TextEditingController();
  bool _isWriting = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      // await _firestore.collection('messages').add({
      //   'text': messageController.text,
      //   // 'from': widget.user.email,
      //   'date': DateTime.now().toIso8601String().toString(),
      // });

      File recordFile = File(_recording?.path);
      print(recordFile.toString());
      _homeController.sendChatMessage(widget.phone, messageController.text);
      _homeController.getChatList(widget.phone);
      messageController.clear();
      setState(() {
        _isWriting = false;
      });
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppBarWidget().showAppBar(
                context, SharedWidget.arrowBack(), nullWedgit(), call()),
          ),
          Text(DemoLocalizations.of(context).title['_hello'] , style: TextStyle(fontSize: MediaQuery.of(context).size.width/25),),

          Flexible(
            fit: FlexFit.tight,
            child: StreamBuilder(
              stream: _homeController.getChatListStream.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print('chat data ');
                  return _realData(snapshot.data);
                } else {
                  return _splash();
                }
              },
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            child: Column(
              children: <Widget>[
                //     Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[

                //     Text(
                //       'Status',
                //       style: Theme.of(context).textTheme.title,
                //     ),
                //     SizedBox(
                //       height: 5,
                //     ),
                //     Text(
                //       '${_recording?.status ?? "-"}',
                //       style: Theme.of(context).textTheme.body1,
                //     ),
                //     SizedBox(
                //       height: 20,
                //     ),
                //     RaisedButton(
                //       child: Text('Play'),
                //       disabledTextColor: Colors.white,
                //       disabledColor: Colors.grey.withOpacity(0.5),
                //       onPressed: _recording?.status == RecordingStatus.Stopped
                //           ? _play
                //           : null,
                //     ),
                //     SizedBox(
                //       height: 20,
                //     ),
                //     Text(
                //       '${_alert ?? ""}',
                //       style: Theme.of(context)
                //           .textTheme
                //           .title
                //           .copyWith(color: Colors.red),
                //     ),
                //   ],
                // ),
                _buildComposer(),
              ],
            ),
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          ),

          // Flexible(
          //     child: new ListView.builder(
          //   itemBuilder: (_, int index) => _messages[index],
          //   itemCount: _messages.length,
          //   reverse: true,
          //   padding: new EdgeInsets.all(6.0),
          // )),
          // new Divider(height: 1.0),
          // new Container(
          //   child: _buildComposer(),
          //   decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          // ),
        ],
      ),
    );
  }

  Widget _realData(List data) {
    return ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Message(
            pathAudio: data[index]['record_path'],
            adminId: data[index]['admin_id'],
            text: data[index]['message'],
            animationController: AnimationController(
                vsync: this, duration: new Duration(milliseconds: 800)),
          ),
        );
      },
    );
  }

  Widget _splash() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: messageController,
                  onChanged: (String txt) {
                    setState(() {
                      _isWriting = txt.length > 0;
                    });
                  },
                  onSubmitted: _submitMsg,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Enter some text to send a message"),
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/25),
                ),
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 3.0),
                child: !_isWriting
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: InkWell(
                          child: _buttonIcon,
                          onTap: () {
                            _opt();
                          },
                        ),
                      )
                    : new IconButton(
                        icon: new Icon(
                          Icons.send,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          callback();
                          //                     _homeController.sendChatMessage(widget.phone,messageController.text,"");
                          //                      _homeController.getChatList(widget.phone);
                          //                       messageController.clear();
                          // setState(() {
                          //   _isWriting = false;
                          // });
                          // scrollController.animateTo(
                          //   scrollController.position.maxScrollExtent,
                          //   curve: Curves.easeOut,
                          //   duration: const Duration(milliseconds: 300),
                          // );
                        },
                      ),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border: new Border(top: new BorderSide(color: Colors.brown)))
              : null),
    );
  }

  void _submitMsg(String txt) {
    messageController.clear();
    setState(() {
      _isWriting = false;
    });
    Msg msg = new Msg(
      txt: txt,
      animationController: new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 800)),
    );
    setState(() {
      _messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});
  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext ctx) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipPath(
                    clipper: ChatClipper(),
                    child: new Container(
                      decoration: BoxDecoration(
                        color: Color(0xffEBDE8C),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12)),
                      ),
                      margin: const EdgeInsets.only(top: 6.0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 30, left: 8, right: 8),
                        child: new Text(
                          txt,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String text;
  final String pathAudio;
  final Recording recording;
  final AnimationController animationController;
  final int adminId;

  void _play() {
    //AudioPlayer player = AudioPlayer();
    //player.play(recording.path, isLocal: true);
  }

  const Message(
      {Key key,
      this.text,
      this.animationController,
      this.adminId,
      this.pathAudio,
      this.recording})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: adminId != 1 ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment:
            // me ? CrossAxisAlignment.end :
            CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   from,
          // ),
          ClipPath(
            clipper: adminId != 1 ? ChatClipper() : ChatClipper2(),
            child: new Container(
              decoration: BoxDecoration(
                color: adminId != 1 ? Color(0xffEBDE8C) : Colors.grey[400],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12)),
              ),
              margin: const EdgeInsets.only(top: 6.0),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 30, left: 8, right: 8),
                child: Column(
                  children: <Widget>[
                    new Text(
                      text == null ? "" : text,
                      style: TextStyle(color: Colors.black , fontSize: MediaQuery.of(context).size.width/25),
                    ),
                    pathAudio == null
                        ? SizedBox(
                            width: 2,
                            height: 2,
                          )
                        : RaisedButton(
                            child: Text('Play'),
                            disabledTextColor: Colors.white,
                            disabledColor: Colors.grey.withOpacity(0.5),
                            onPressed:
                                recording?.status == RecordingStatus.Stopped
                                    ? _play
                                    : null,
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
