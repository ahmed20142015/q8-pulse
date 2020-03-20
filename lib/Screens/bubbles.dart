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
import 'package:webview_flutter/webview_flutter.dart';

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
                //vc.dispose();
              } else {
              }
            },
          ),
        ],
      ),
    );
  }

  //VideoController vc;
  ScrollController controllerVideo = ScrollController();
/////////////////////////////////////////////////////////////////////////////
  ///Here we should replace the webview with a videoplayer
  Widget videoWidget() {
    return StreamBuilder(
      stream: _homeController.videoDataStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('video data');
          ///true
          ///snapshot.data['status']== "ACTIVE" snapshot.data['status']== "ACTIVE"
          if (true) {
            return Container(
              height: 200,




              
              child:
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child:
                      ///put the webview content here
                      WebView(
                        initialUrl: "http://static.france24.com/live/F24_EN_LO_HLS/live_web.m3u8",
                        //initialUrl: ConstantVarable.videoUrl,
                        javascriptMode: JavascriptMode.unrestricted,
                      )

                      /*
                      VideoBox(
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
                    */
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


  @override
  void initState() {
    super.initState();

// ShowsController().showLogic();
    print("google Ingormation " + widget.googleInfo.toString());

    print("user Information ${widget.userId}  ${widget.phone} , ${widget.firstName} , ${widget.lastName} , ${widget.userImage}  ");


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
///Radio Part
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
}

