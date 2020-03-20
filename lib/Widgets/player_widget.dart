import 'dart:async';

import 'package:flutter_exoplayer/audio_notification.dart';
import 'package:flutter_exoplayer/audioplayer.dart';

import 'package:flutter/material.dart';
import 'package:q8_pulse/Controllers/HomeController.dart';

import 'package:q8_pulse/Screens/chat_screen.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';
import 'package:flutter_radio/flutter_radio.dart';

const imageUrl1 = "https://www.bensound.com/bensound-img/buddy.jpg";
const imageUrl2 = "https://www.bensound.com/bensound-img/epic.jpg";
const imageUrl3 = "https://www.bensound.com/bensound-img/onceagain.jpg";

class PlayerWidget extends StatefulWidget {
  final String url;
  final List<String> urls;
  String phone;
  final String urlRingTone;
  int guestId;

  PlayerWidget(
      {this.url, this.urls, this.phone, this.urlRingTone, this.guestId});

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState(url, urls);
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String url;
  List<String> urls;

  AudioPlayer _audioPlayer;
  Duration _duration;
  Duration _position;
  int _currentIndex = 0;

  PlayerState _playerState = PlayerState.RELEASED;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription _playerIndexSubscription;
  StreamSubscription _playerAudioSessionIdSubscription;
  StreamSubscription _notificationActionCallbackSubscription;

  final List<AudioNotification> audioNotifications = [
    AudioNotification(
      smallIconFileName: "ic_launcher",
      title: "title1",
      subTitle: "artist1",
      largeIconUrl: imageUrl1,
      isLocal: false,
      notificationDefaultActions: NotificationDefaultActions.ALL,
      notificationCustomActions: NotificationCustomActions.TWO,
    ),
    AudioNotification(
        smallIconFileName: "ic_launcher",
        title: "title2",
        subTitle: "artist2",
        largeIconUrl: imageUrl2,
        isLocal: false,
        notificationDefaultActions: NotificationDefaultActions.ALL),
    AudioNotification(
        smallIconFileName: "ic_launcher",
        title: "title3",
        subTitle: "artist3",
        largeIconUrl: imageUrl3,
        isLocal: false,
        notificationDefaultActions: NotificationDefaultActions.ALL),
  ];

  get _isPlaying => _playerState == PlayerState.PLAYING;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  _PlayerWidgetState(this.url, this.urls);

  bool isPlaying;
  bool isPlayingLocale = false ;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    audioStart();
    playingStatus();

  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerIndexSubscription?.cancel();
    _playerAudioSessionIdSubscription?.cancel();
    _notificationActionCallbackSubscription?.cancel();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 15,
                      height: MediaQuery.of(context).size.height / 15,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            ///MSG Icon
                              image: AssetImage(
                                  "assets/imgs/ic_msg_dark@3x.png"))),
                    ),
                  ],
                ),
              ),
              onTap: () {
                if (widget.guestId != 015) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                phone: widget.phone,
                              )));
                } else {
                  SharedWidget.dialogLogin(context);
                }
              },
            ),
            IconButton(
              onPressed: _isPlaying
                  ? () => _pause()
                  : () {
                      _playerState == PlayerState.RELEASED
                          ? _play()
                          : _resume();
                    },
              iconSize: 80.0,
              icon: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 15,
                  backgroundColor: Color(0xffFFBF31),
                  child:    isPlayingLocale==true
                      ? InkWell(
                        child: Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width / 12,
                  ),onTap: (){
                    FlutterRadio.stop();
                    setState(() {
                      isPlayingLocale=false;
                    });

                  },
                      )
                      : InkWell(
                        child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width / 12,
                  ),onTap: (){
                    FlutterRadio.play(url: widget.url);
                    setState(() {
                      isPlayingLocale=true;
                    });

                  },
                      )

              ),
            ),
            InkWell(
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 15,
                      height: MediaQuery.of(context).size.height / 15,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/imgs/ic_call@3x.png"))),
                    ),
                  ],
                ),
              ),
              onTap: () {
                HomeController().onJoin(context, widget.phone, widget.guestId);
                _pause();
                FlutterRadio.stop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }
  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying = isP;
      print("status is : $isPlaying");
    });
  }

  String getUrlMatchingImage() {
    if (url == imageUrl1) {
      return imageUrl1;
    } else if (url == imageUrl2) {
      return imageUrl2;
    } else if (url == imageUrl2) {
      return imageUrl3;
    } else {
      return imageUrl1;
    }
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _positionSubscription = _audioPlayer.onAudioPositionChanged.listen((pos) {
      setState(() {
        _position = pos;
      });
    });
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((playerState) {
      setState(() {
        _playerState = playerState;
        print(_playerState);
      });
    });
    _playerIndexSubscription =
        _audioPlayer.onCurrentAudioIndexChanged.listen((index) {
      setState(() {
        _position = Duration(milliseconds: 0);
        _currentIndex = index;
      });
    });
    _playerAudioSessionIdSubscription =
        _audioPlayer.onAudioSessionIdChange.listen((audioSessionId) {
      print("audio Session Id: $audioSessionId");
    });
    _notificationActionCallbackSubscription = _audioPlayer
        .onNotificationActionCallback
        .listen((notificationActionName) {
      //do something
    });
    _playerCompleteSubscription = _audioPlayer.onPlayerCompletion.listen((a) {
      _position = Duration(milliseconds: 0);
    });
  }
///play method
  Future<void> _play() async {
    print("play");
    if (url != null) {
      final Result result = await _audioPlayer.play(
        url,
        repeatMode: true,
        respectAudioFocus: false,
        playerMode: PlayerMode.BACKGROUND,
      );
      if (result == Result.ERROR) {
        print("something went wrong in play method :(");
      }
    } else {
      final Result result = await _audioPlayer.playAll(
        urls,
        repeatMode: false,
        respectAudioFocus: true,
        playerMode: PlayerMode.FOREGROUND,
        audioNotifications: audioNotifications,
      );
      if (result == Result.ERROR) {
        print("something went wrong in playAll method :(");
      }
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

  Future<void> _stop() async {
    final Result result = await _audioPlayer.stop();
    if (result == Result.FAIL) {
      print(
          "you tried to call audio conrolling methods on released audio player :(");
    } else if (result == Result.ERROR) {
      print("something went wrong in stop :(");
    }
  }
/*
  Future<void> _release() async {
    final Result result = await _audioPlayer.release();
    if (result == Result.FAIL) {
      print(
          "you tried to call audio conrolling methods on released audio player :(");
    } else if (result == Result.ERROR) {
      print("something went wrong in release :(");
    }
  }
  Future<void> _next() async {
    final Result result = await _audioPlayer.next();
    if (result == Result.FAIL) {
      print(
          "you tried to call audio conrolling methods on released audio player :(");
    } else if (result == Result.ERROR) {
      print("something went wrong in next :(");
    }
  }
  Future<void> _previous() async {
    final Result result = await _audioPlayer.previous();
    if (result == Result.FAIL) {
      print(
          "you tried to call audio conrolling methods on released audio player :(");
    } else if (result == Result.ERROR) {
      print("something went wrong in previous :(");
    }
  }

  Widget _realNameShow(String showName) {
    return Column(
      children: <Widget>[
        Text(
          showName == null ? "" : "$showName",
          style: TextStyle(fontSize: 15, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _realTimeShow(String form, String to) {
    return Column(
      children: <Widget>[
        Text(
          form == null ? "" : "$form - $to",
          style: TextStyle(fontSize: 15, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _splash() {
    return Center(
        child: Text(
      DemoLocalizations.of(context).title['q8_pulse_broadcasting'],
      style: TextStyle(fontSize: 15, color: Colors.grey[500]),
    ));
  }
  */




}
