import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exoplayer/audioplayer.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:q8_pulse/Controllers/HomeController.dart';
import '../utils/settings.dart';

class CallPage extends StatefulWidget {
  
  /// non-modifiable channel name of the page
  final String channelName;
  final String phone ;
  final String urlRingTone ;



  /// Creates a call page with given channel name.
  const CallPage({Key key, this.channelName , this.phone , this.urlRingTone}) : super(key: key);

  @override
  _CallPageState createState() {
    return new _CallPageState();
  }
}

class _CallPageState extends State<CallPage> {
  static final _users = List<int>();
  final _infoStrings = <String>[];
  bool muted = true;
  bool spekared = true;
Timer _timer1;
Timer _timer2;
  int counter1 = 0;
  int counter2 = 0;
  int _callId ;

  void onNoJoin(BuildContext context , int counter){
    print("conter is  $counter ");
    if(counter > 30){
      if(_users.length==0){
        HomeController().missedCall(_callId);
        print("not joined");
        Navigator.pop(context);
      }else{
        _pause();
      }
    }
  }
void startTimerMin(){
const oneMin = const Duration(minutes: 1);
   _timer2 = new Timer.periodic(
      oneMin,
      (Timer timer) => setState((){
            counter2 = counter2 +1; 
           
        },
      ),
    );
}
    void startTimerSec() async {
  
    const oneSec = const Duration(seconds: 1);
        
    _timer1 = new Timer.periodic(
      oneSec,
      (Timer timer) => setState((){
            counter1 = counter1 + 1;
            onNoJoin(context, counter1);
            if(counter1==60){
              _timer1.cancel();

              counter1=0;
              startTimerSec();
            }
           
        },
      ),
    );

    
     
  }
  @override
  void dispose() {
    // clear users
    _timer1.cancel();
    _timer2.cancel();
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
    startTimerSec();
    startTimerMin();
    HomeController().postCall(widget.phone , widget.channelName).then((callId){
      setState(() {
        _callId = callId;
      });
    });
    _initAudioPlayer();
    print("users lingth is  ${_users.length}");



  }

  void initialize() {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings
            .add("APP_ID missing, please provide your APP_ID in settings.dart");
        _infoStrings.add("Agora Engine is not starting");
      });
      return;
    }

    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    AgoraRtcEngine.enableWebSdkInteroperability(true);
    AgoraRtcEngine.setParameters('{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}');
    AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialze
  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create(APP_ID);
    AgoraRtcEngine.enableVideo();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        String info = 'onError: ' + code.toString();
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
        HomeController().endCall(_callId);
        Navigator.pop(context);
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        String info = 'userJoined: ' + uid.toString();
        _infoStrings.add(info);
        _users.add(uid);
        _pause();
        HomeController().startCall(_callId);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        String info = 'userOffline: ' + uid.toString();
        _infoStrings.add(info);
        _users.remove(uid);
      });
      Navigator.pop(context);
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      setState(() {
        String info = 'firstRemoteVideo: ' +
            uid.toString() +
            ' ' +
            width.toString() +
            'x' +
            height.toString();
        _infoStrings.add(info);
      });
    };
  }


  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    List<Widget> list = [AgoraRenderWidget(0, local: true, preview: true)];
    _users.forEach((int uid) => {
      list.add(AgoraRenderWidget(uid))
    });
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    List<Widget> wrappedViews =
        views.map((Widget view) => _videoView(view)).toList();
    return Expanded(
        child: Row(
      children: wrappedViews,
    ));
  }

  /// Video layout wrapper
  Widget _viewRows() {
    List<Widget> views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _onToggleMute(),
            child: new Icon(
              muted ? Icons.mic : Icons.mic_off,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: new Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: () => _onToggleSpekar(),
            child: spekared ? new Icon(
              Icons.speaker_phone,
              color: Colors.blueAccent,
              size: 20.0,
            ): new Icon(
              Icons.speaker,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: ListView.builder(
                  reverse: true,
                  itemCount: _infoStrings.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_infoStrings.length == 0) {
                      return null;
                    }
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.yellowAccent,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(_infoStrings[index],
                                      style:
                                          TextStyle(color: Colors.blueGrey))))
                        ]));
                  })),
        ));
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }



  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  void _onToggleSpekar(){
    setState(() {
      spekared = !spekared;
    });
      AgoraRtcEngine.setEnableSpeakerphone(spekared);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        backgroundColor: Colors.black,
        body: Center(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/imgs/Logo_home_dark@3x.png"),fit: BoxFit.cover
                )
              ),
              child: Column(
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.only(top: 150 , bottom: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text( "$counter2 : $counter1 " , style: TextStyle(
                          fontSize: 18 ,
                          color: Colors.grey[400]
                        ),)
                      ],
                    ),
                  ),
                  Stack(
          children: <Widget>[
                  // _viewRows(),
                  //  _panel(),
                    _toolbar()],
        ),

//                  IconButton(
//                    onPressed: _isPlaying
//                        ? () => _pause()
//                        : () {
//                      _playerState == PlayerState.RELEASED ? _play() : _resume();
//                    },
//                    iconSize: 80.0,
//                    icon: CircleAvatar(
//                        radius: 30,
//                        backgroundColor: Color(0xffFFBF31),
//                        child: _isPlaying
//                            ? Icon(
//                          Icons.pause,
//                          color: Colors.white,
//                          size: 30,
//                        )
//                            : Icon(
//                          Icons.play_arrow,
//                          color: Colors.white,
//                          size: 40,
//                        )),
//                  ),
                ],
              ),
            )));
  }
  String url = 'http://162.244.80.118:3020/stream.mp3';


  AudioPlayer _audioPlayer;
  PlayerState _playerState = PlayerState.RELEASED;
  get _isPlaying => _playerState == PlayerState.PLAYING;
  StreamSubscription _playerStateSubscription;
  Future<void> _play() async {
    print("play");
    if (widget.urlRingTone != null) {
      final Result result = await _audioPlayer.play(
        widget.urlRingTone,
        repeatMode: true,
        respectAudioFocus: false,
        playerMode: PlayerMode.BACKGROUND,
      );
      if (result == Result.ERROR) {
        print("something went wrong in play method :(");
      }else{
        print("play is done");
      }
    } else {
        print("url is null");

    }
  }
  Future<void> _resume() async {
    print("resume");
    final Result result = await _audioPlayer.resume();
    if (result == Result.FAIL) {
      print(
          "you tried to call audio conrolling methods on released audio player :(");
    } else if (result == Result.ERROR) {
      print("something went wrong in resume :(");
    }
  }
  Future<void> _pause() async {
    final Result result = await _audioPlayer.pause();
    if (result == Result.FAIL) {
      print(
          "you tried to call audio conrolling methods on released audio player :(");
    } else if (result == Result.ERROR) {
      print("something went wrong in pause :(");
    }
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((playerState) {
          setState(() {
            _playerState = playerState;
            print(_playerState);
          });
        });
    _play();
    FlutterRadio.stop();

  }


}
