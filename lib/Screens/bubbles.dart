import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/HomeController.dart';
import 'package:q8_pulse/Controllers/UserController.dart';
import 'package:q8_pulse/Data/Models/ScopeModelWrapper.dart';
import 'package:q8_pulse/Data/Models/ThemeModel.dart';
import 'package:q8_pulse/Screens/chat_screen.dart';
import 'package:q8_pulse/Widgets/AppBarWidget.dart';
import 'package:q8_pulse/Widgets/BroadcastersCard.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/Widgets/drawer_widget.dart';
import 'package:q8_pulse/Widgets/player_widget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:video_box/video.controller.dart';
import 'package:video_box/video_box.dart';
import 'package:video_player/video_player.dart';

const kUrl1 = 'http://162.244.80.118:3020/stream.mp3';
const kUrl2 = 'https://www.bensound.org/bensound-music/bensound-epic.mp3';
const kUrl3 = 'https://www.bensound.org/bensound-music/bensound-onceagain.mp3';

class BubblesScreen extends StatefulWidget {
  int userId;
  String phone;
  String firstName;
  String lastName;
  String userImage;
  List<String> googleInfo;

  BubblesScreen(
      {this.phone,
      this.firstName,
      this.lastName,
      this.userImage,
      this.googleInfo,
      this.userId});
  createState() => BubblesView();
}

class BubblesView extends StateMVC<BubblesScreen>
    with SingleTickerProviderStateMixin {
  BubblesView() : super(HomeController()) {
    _homeController = HomeController.con;
  }
  HomeController _homeController;


  Widget _realPresentersData(List data) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return BroadcastersCard(
            position: index,
            data: data[index],
            guestId : widget.userId,
          );
        },
      ),
    );
  }

  Widget _realHomeAddsData(List data) {
    return CarouselSlider(
      height: MediaQuery.of(context).size.height / 2,
      viewportFraction: 0.9,
      aspectRatio: 5.0,
      autoPlay: true,
      enlargeCenterPage: true,
      autoPlayInterval: Duration(seconds: 30),
      items: data.map(
        (url) {
          return Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Image.network(
                "${ConstantVarable.apiImg}$url",
                fit: BoxFit.cover,
                width: 1000.0,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _splash() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget pageView() {
    _homeController.whatDisplayNow();
    _homeController.getAllAddsForHome();
    return StreamBuilder(

      stream: _homeController.getwhatDisplayNowStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('what Desplay now Adds Data');
          return _realHomeAddsData(snapshot.data['image_banner']);
        } else {
          return StreamBuilder(
            stream: _homeController.getHomeAddsStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('Home Adds Data');
                return _realHomeAddsData(snapshot.data);
              } else {
                return _splash();
              }
            },
          );
        }
      },
    );
  }

  Widget menu() {
    return InkWell(
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(valueMode == true ? "assets/imgs/menu_light.png" :"assets/imgs/menu.png"))),
      ),
      onTap: () {
        _scaffoldKeyHome.currentState.openDrawer();
      },
    );
  }

  Widget logo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(valueMode==true ? "assets/imgs/Logo_home_dark@3x.png" : "assets/imgs/88.8-Final-logo.png"))),
    );
  }

  Widget nullWedgit() {
    return Container(
      width: 30,
      height: 30,
    );
  }



  final GlobalKey<ScaffoldState> _scaffoldKeyHome =
      new GlobalKey<ScaffoldState>();

  bool valueMode = true;
  bool valueLang = true;
  bool valueVorO = true;

  Widget switcherWidget() {
    return CupertinoSwitch(
      activeColor: Color(0xffF2C438),
      value: valueMode,
      onChanged: (value) {
        setState(() {
          valueMode = value;
        });

        Provider.of<ThemeModel>(context).toggleTheme();
      },
    );
  }

  Widget switcherLanguageWidget(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => CupertinoSwitch(
        activeColor: Color(0xffF2C438),
        value: valueLang,
        onChanged: (value) {
          setState(() {
            valueLang = value;
          });
          model.changeDirection(widget.phone);
          _homeController.getAllPresenters();
        },
      ),
    );
  }



  Widget switchervideoOrAudioWidget(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Container(
              height: MediaQuery.of(context).size.height/20,
              width: MediaQuery.of(context).size.width / 2.2,
              decoration: BoxDecoration(
                  color: valueVorO == true ? Color(0xffF2C438) : Colors.grey[800],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    DemoLocalizations.of(context).title['_audio'],
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width/23 , color: Colors.grey[200]),
                  ),
                ),
              ),
            ),
            onTap: () {
              setState(() {
                valueVorO = true;
              });
            },
          ),
          InkWell(
            child: Container(
              height: MediaQuery.of(context).size.height/20,
              width: MediaQuery.of(context).size.width / 2.2,
              decoration: BoxDecoration(
                  color:
                      valueVorO == false ? Color(0xffF2C438) : Colors.grey[800],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    DemoLocalizations.of(context).title['_video'],
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width/23 , color: Colors.grey[200]),
                  ),
                ),
              ),
            ),
            onTap: () {
              print("video url is ${ConstantVarable.videoUrl}");
              setState(() {
                valueVorO = false;
              });
              _homeController.getVideoData();
              if (valueVorO == true) {
                vc.dispose();
              } else {
                vc = VideoController(
                  source: VideoPlayerController.network(ConstantVarable.videoUrl),
                  looping: true,
                  autoplay: true,
                  color: Color(0xffF2C438),
                  bufferColor: Color(0xffF2C438),
                  inactiveColor: Colors.grey[800],
                  background: Colors.grey[800],
                  circularProgressIndicatorColor: Color(0xffF2C438),
                  bottomPadding: EdgeInsets.only(bottom: 10),
                  customLoadingWidget: Center(
                    child: Container(
                      color: Colors.grey[800],
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text("Lading...",style: TextStyle(color: Colors.grey[400])),
                        ],
                      ),
                    ),
                  ),
                  customBufferedWidget: Center(
                    child: Container(

                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text("please wait..." , style: TextStyle(color: Colors.grey[400]),),
                        ],
                      ),
                    ),
                  ),
                  customFullScreen: MyFullScreen(),
                  // cover: Image.network('https://i.loli.net/2019/08/29/7eXVLcHAhtO9YQg.jpg'),
                  // controllerWidgets: false,
                  // cover: Text('Cover'),
                  // initPosition: Duration(minutes: 23, seconds: 50)
                )
                  ..addFullScreenChangeListener((c) async {})
                  ..initialize().then((_) {
                    // initialized
                  });
              }
            },
          ),
        ],
      ),
    );
  }

  VideoController vc;
  ScrollController controllerVideo = ScrollController();

  Widget videoWidget() {
    return StreamBuilder(
      stream: _homeController.videoDataStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('video data');
          if (snapshot.data['status'] == "ACTIVE") {
            return Container(
              height: 200,

              child:
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoBox(
                        controller: vc,
                        children: <Widget>[
                          Align(
                            alignment: Alignment(0.5, 0),
                            child: IconButton(
                              iconSize: VideoBox.centerIconSize,
                              disabledColor: Colors.white60,
                              icon: Icon(Icons.skip_next),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

            );
          } else {
            return ScopedModelDescendant<AppModel>(
              builder: (context, child, model) {
                return Center(
                  child: Text(
                    model.appLocale == Locale('en')
                        ? "${snapshot.data['suspend_message_en']}"
                        : "${snapshot.data['suspend_message_ar']}",
                    style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                  ),
                );
              },
            );
          }
        } else {
          print("video data null");
          return _splash();
        }
      },
    );
  }

  Timer timer;

  List<VideoController> vcs = [];
  @override
  void initState() {
    super.initState();

// ShowsController().showLogic();
    print("google Ingormation " + widget.googleInfo.toString());

    print("user Information ${widget.userId}  ${widget.phone} , ${widget.firstName} , ${widget.lastName} , ${widget.userImage}  ");
    // timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
    //   var now = new DateTime.now();
    //   var formatterTime = new DateFormat('HH:mm:ss');
    //   var formatterDay = new DateFormat('EEEE');
    //   String formattedTime = formatterTime.format(now);
    //   String formatedDay = formatterDay.format(now);
    //   switcherDay(formatedDay, formattedTime);

    //   print(formattedTime);
    //   print(formatedDay);
    // });

    _homeController.whatDisplayNow();
    _homeController.getAllPresenters();
    _homeController.getAllAddsForHome();
    _homeController.getVideoData();

    // Initialize bubbles
  }

  @override
  void dispose() {
    //   vc.dispose();
    // _scaffoldKeyHome.currentState.deactivate();
    BubblesView();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget().showAppBar(context, menu(), logo(), SharedWidget.shareWidget(context, valueMode)),
      key: _scaffoldKeyHome,
      drawer: DrawerW().showDrawer(
          context,
          switcherWidget(),
          switcherLanguageWidget(context),
          valueMode,
          widget.userImage,
          widget.firstName,
          widget.lastName,
          widget.googleInfo,
          _scaffoldKeyHome,
      widget.userId),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              switchervideoOrAudioWidget(context),
              StreamBuilder(
                stream: _homeController.getShowPresentersStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print('all presenters has data ');
                    return _realPresentersData(snapshot.data);
                  } else {
                    return StreamBuilder(
                      stream: _homeController.getAllPresentersStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print('all presenters has data ');
                          return _realPresentersData(snapshot.data);
                        } else {
                          return _splash();
                        }
                      },
                    );
                  }
                },
              ),
              valueVorO == true
                  ? Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: pageView(),
                    )
                  : videoWidget(),
              valueVorO == true
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      PlayerWidget(
                          url: kUrl1,
                        phone: widget.phone,
                        guestId: widget.userId,
                        ),



                    ],
                  )
                  : Container(),

            ],
          ),
        ),
      ),
    );
  }

//  void switcherDay(String day, String time) {
//    switch (day) {
//      case "Saturday":
//        {
//          ScheduleController().getCheduleforAdds("1", time);
//          print('Saturday data');
//        }
//        break;
//
//      case "Sunday":
//        {
//          ScheduleController().getCheduleforAdds("2", time);
//          print('Sunday data');
//        }
//        break;
//
//      case "Monday":
//        {
//          ScheduleController().getCheduleforAdds("1", time);
//          print('Monday data');
//        }
//        break;
//
//      case "Tuesday":
//        {
//          ScheduleController().getCheduleforAdds("4", time);
//          print('Tuesday data');
//        }
//        break;
//
//      case "Wednesday":
//        {
//          ScheduleController().getCheduleforAdds("5", time);
//          print('Wednesday data');
//        }
//        break;
//
//      case "Thursday":
//        {
//          ScheduleController().getCheduleforAdds("6", time);
//          print('Thursday data');
//        }
//        break;
//
//      case "Friday":
//        {
//          ScheduleController().getCheduleforAdds("7", time);
//          print('Friday data');
//        }
//        break;
//
//      default:
//        {
//          print("no data");
//        }
//        break;
//    }
//  }
}

typedef Widget VideoWidgetBuilder(
    BuildContext context, VideoPlayerController controller);

abstract class PlayerLifeCycle extends StatefulWidget {
  PlayerLifeCycle(this.dataSource, this.childBuilder);

  final VideoWidgetBuilder childBuilder;
  final String dataSource;
}

/// A widget connecting its life cycle to a [VideoPlayerController] using
/// a data source from the network.
class NetworkPlayerLifeCycle extends PlayerLifeCycle {
  NetworkPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
      : super(dataSource, childBuilder);

  @override
  _NetworkPlayerLifeCycleState createState() => _NetworkPlayerLifeCycleState();
}

/// A widget connecting its life cycle to a [VideoPlayerController] using
/// an asset as data source
class AssetPlayerLifeCycle extends PlayerLifeCycle {
  AssetPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
      : super(dataSource, childBuilder);

  @override
  _AssetPlayerLifeCycleState createState() => _AssetPlayerLifeCycleState();
}

abstract class _PlayerLifeCycleState extends State<PlayerLifeCycle> {
  VideoPlayerController controller;

  @override

  /// Subclasses should implement [createVideoPlayerController], which is used
  /// by this method.
  void initState() {
    super.initState();
    controller = createVideoPlayerController();
    controller.addListener(() {
      if (controller.value.hasError) {
        print(controller.value.errorDescription);
      }
    });
    controller.initialize();
    controller.setLooping(true);
    controller.play();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.childBuilder(context, controller);
  }

  VideoPlayerController createVideoPlayerController();
}

class _NetworkPlayerLifeCycleState extends _PlayerLifeCycleState {
  @override
  VideoPlayerController createVideoPlayerController() {
    return VideoPlayerController.network(widget.dataSource);
  }
}

class _AssetPlayerLifeCycleState extends _PlayerLifeCycleState {
  @override
  VideoPlayerController createVideoPlayerController() {
    return VideoPlayerController.asset(widget.dataSource);
  }
}

class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    listener = () {
      if (!mounted) {
        return;
      }
      if (initialized != controller.value.initialized) {
        initialized = controller.value.initialized;
        setState(() {});
      }
    };
    controller.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayPause(controller),
        ),
      );
    } else {
      return Container();
    }
  }
}

class VideoPlayPause extends StatefulWidget {
  VideoPlayPause(this.controller);

  final VideoPlayerController controller;

  @override
  State createState() {
    return _VideoPlayPauseState();
  }
}

class _VideoPlayPauseState extends State<VideoPlayPause> {
  _VideoPlayPauseState() {
    listener = () {
      SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
    };
  }

  FadeAnimation imageFadeAnim =
      FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
  VoidCallback listener;

  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
    controller.setVolume(1.0);
    controller.play();
  }

  @override
  void deactivate() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.setVolume(0.0);
      controller.removeListener(listener);
    });

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      GestureDetector(
        child: VideoPlayer(controller),
        onTap: () {
          if (!controller.value.initialized) {
            return;
          }
          if (controller.value.isPlaying) {
            imageFadeAnim =
                FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
            controller.pause();
          } else {
            imageFadeAnim =
                FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
            controller.play();
          }
        },
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: VideoProgressIndicator(
          controller,
          allowScrubbing: true,
        ),
      ),
      Center(child: imageFadeAnim),
      Center(
          child: controller.value.isBuffering
              ? const CircularProgressIndicator()
              : null),
    ];

    return Stack(
      fit: StackFit.passthrough,
      children: children,
    );
  }
}

class FadeAnimation extends StatefulWidget {
  FadeAnimation(
      {this.child, this.duration = const Duration(milliseconds: 500)});

  final Widget child;
  final Duration duration;

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animationController.isAnimating
        ? Opacity(
            opacity: 1.0 - animationController.value,
            child: widget.child,
          )
        : Container();
  }
}

class MyFullScreen implements CustomFullScreen {
  @override
  void close(BuildContext context, VideoController controller) {
    Navigator.of(context).pop(controller.value.positionText);
  }

  @override
  Future open(BuildContext context, VideoController controller) async {
    setLandscape();
    SystemChrome.setEnabledSystemUIOverlays([]);
    await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            body: Center(child: VideoBox(controller: controller)),
          );
        },
      ),
    ).then(print);
    setPortrait();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }
}
