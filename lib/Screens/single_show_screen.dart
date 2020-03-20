import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/ShowsController.dart';
import 'package:q8_pulse/Data/Models/ScopeModelWrapper.dart';
import 'package:q8_pulse/Screens/chat_screen.dart';
import 'package:q8_pulse/Widgets/AppBarWidget.dart';
import 'package:q8_pulse/Widgets/PresenterCard.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;


class SingleShowScreen extends StatefulWidget {
  Map<String, dynamic> data;
  bool valueMode;
  String phone;
  int guestId ;
  SingleShowScreen({this.data, this.valueMode, this.phone , this.guestId});
  createState() => SingleShowView();
}

class SingleShowView extends StateMVC<SingleShowScreen> {
  SingleShowView() : super(ShowsController()) {
    _showsController = ShowsController.con;
  }

  ShowsController _showsController;

  final GlobalKey<ScaffoldState> _scaffoldKeySingleShow =
      new GlobalKey<ScaffoldState>();

  initState() {
    super.initState();
    _showsController.getShowPresenters(widget.data['id'].toString());

    _showsController.getAirTimes(widget.data['id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    Widget bill() {
      return Container(
        width: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(widget.valueMode == true
                            ? "assets/imgs/envelope.png"
                            : "assets/imgs/envelopeLite.png"))),
              ),
              onTap: () {
                if(widget.guestId != 015) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(
                                phone: widget.phone,
                              )));
                }else{
                  SharedWidget.dialogLogin(context);
                }
              },
            ),
            InkWell(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(widget.valueMode == true
                            ? "assets/imgs/ic_alarm@3x.png"
                            : "assets/imgs/bell.png"))),
              ),
              onTap: () {},
            )
          ],
        ),
      );
    }

    Widget nullWedgit() {
      return Container(
        width: 25,
        height: 25,
      );
    }

    return Scaffold(
      key: _scaffoldKeySingleShow,
      body: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(ConstantVarable.apiImg +
                                        widget.data["image"] ==
                                    null
                                ? "assets/imgs/broadcaster1.png"
                                : ConstantVarable.apiImg + widget.data["image"]),
                            fit: BoxFit.cover)),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: AppBarWidget().showAppBar(context,
                          SharedWidget.arrowBack(), nullWedgit(), bill()),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            model.appLocale == Locale('ar')
                                ? widget.data['title_ar'] == null
                                    ? ""
                                    : widget.data['title_ar']
                                : widget.data['title_en'] == null
                                    ? ""
                                    : widget.data['title_en'],
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/25,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                      Html(
                                        data: """
    <!--For a much more extensive example, look at example/main.dart-->
    <div>
      <p> ${model.appLocale == Locale('ar')
                                            ? widget.data['description2_ar'] == null
                                                ? ""
                                                : widget.data['description2_ar']
                                            : widget.data['description2_en'] == null
                                                ? ""
                                                : widget.data['description2_en']},</p>
     
      <!--You can pretty much put any html in here!-->
    </div>
  """,
                                        //Optional parameters:
                                        padding: EdgeInsets.all(0.0),
                                        backgroundColor: Colors.grey[800],


                                        linkStyle: const TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                        onLinkTap: (url) {
                                          // open url in a webview
                                        },
                                        onImageTap: (src) {
                                          // Display the image in large form.
                                        },
                                        //Must have useRichText set to false for this to work.


                                        customTextStyle: (dom.Node node, TextStyle baseStyle) {
                                          if (node is dom.Element) {
                                            switch (node.localName) {
                                              case "p":
                                                return baseStyle.merge(TextStyle(height: 2, fontSize: MediaQuery.of(context).size.width/25 , color: Colors.grey[500]));
                                            }
                                          }
                                          return baseStyle;
                                        },
                                      )

//                                    Text(
//                                      model.appLocale == Locale('ar')
//                                          ? widget.data['description2_ar'] == null
//                                              ? ""
//                                              : widget.data['description2_ar']
//                                          : widget.data['description2_en'] == null
//                                              ? ""
//                                              : widget.data['description2_en'],
//                                      style: TextStyle(
//                                          fontSize: 15, color: Colors.grey[500]),
//                                    ),

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Text(
                            DemoLocalizations.of(context).title['_presenters'],
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/25,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Card(

                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: StreamBuilder(
                                        stream: _showsController
                                            .getShowPresentersStream.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            print('all presenters has data ');
                                            return _realPresentersData(
                                                snapshot.data);
                                          } else {
                                            return _splash();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Text(
                            DemoLocalizations.of(context).title['_air_time'],
                            style: TextStyle(
fontSize: MediaQuery.of(context).size.width/23,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 16),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: <Widget>[
                                  StreamBuilder(
                                    stream:
                                        _showsController.getAirTimeStream.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        print('Air time Data ');
                                        return _realAirTimesData(snapshot.data);
                                      } else {
                                        return _splash();
                                      }
                                    },
                                  ),
                                  Container(
                                    height: 25,
                                  )
                                ],
                              ),
                            ),
                          ),
                          // Text(
                          //   "Gallary",
                          //   style:
                          //       TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 8, bottom: 16),
                          //   child: Container(
                          //     height: MediaQuery.of(context).size.height / 7,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(12),
                          //     ),
                          //     child: ListView.builder(
                          //       scrollDirection: Axis.horizontal,
                          //       shrinkWrap: true,
                          //       physics: ClampingScrollPhysics(),
                          //       itemCount: 7,
                          //       itemBuilder: (context, index) {
                          //         return InkWell(
                          //           child: Container(
                          //             width: MediaQuery.of(context).size.width / 4.3,
                          //             decoration: BoxDecoration(
                          //               image: DecorationImage(
                          //                   image: AssetImage(
                          //                       "assets/imgs/hannah-wei-ptLWrQH2wn8-unsplash.png"),
                          //                   fit: BoxFit.cover),
                          //               borderRadius: BorderRadius.circular(12),
                          //             ),
                          //           ),
                          //           onTap: () {
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => GalaryScreen()));
                          //           },
                          //         );
                          //       },
                          //     ),
                          //   ),
                          // ),
                          Text(
                            DemoLocalizations.of(context).title['_social_media'],
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/25,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 16),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 16, bottom: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      InkWell(
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/imgs/facebook-4.png"))),
                                        ),
                                        onTap: () {
                                          if (widget.data['facebook'] == null) {
                                            SharedWidget.showSnackBar(
                                                _scaffoldKeySingleShow,
                                                "There is no special page");
                                          } else {
                                            _uRLface();
                                          }
                                        },
                                      ),
                                      InkWell(
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/imgs/twitter.png"))),
                                        ),
                                        onTap: () {
                                          if (widget.data['twitter'] == null) {
                                            SharedWidget.showSnackBar(
                                                _scaffoldKeySingleShow,
                                                "There is no special page");
                                          } else {
                                            _uRLtwitter();
                                          }
                                        },
                                      ),
                                      InkWell(
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/imgs/instagram.png"))),
                                        ),
                                        onTap: () {
                                          if (widget.data['instagram'] == null) {
                                            SharedWidget.showSnackBar(
                                                _scaffoldKeySingleShow,
                                                "There is no special page");
                                          } else {
                                            _uRLinsta();
                                          }
                                        },
                                      ),
                                      InkWell(
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/imgs/youtube2.png"))),
                                        ),
                                        onTap: () {
                                          if (widget.data['youtupe'] == null) {
                                            SharedWidget.showSnackBar(
                                                _scaffoldKeySingleShow,
                                                "There is no special page");
                                          } else {
                                            _uRLyoutupe();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          gradient: LinearGradient(
                              colors: [Color(0xffF2C438), Color(0xffF29A2E)]),
                        ),
                        height: MediaQuery.of(context).size.height/20,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Padding(
                          padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/imgs/ic_envelope@3x.png"))),
                              ),
                              Container(
                                width: 18,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  DemoLocalizations.of(context)
                                      .title['_message_send'],
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: MediaQuery.of(context).size.width/25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        if(widget.guestId != 015) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(
                                        phone: widget.phone,
                                      )));
                        }else{
                          SharedWidget.dialogLogin(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _realPresentersData(List data) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return PresenterCard(
            data: data[index],
          );
        },
      ),
    );
  }

  Widget _splash() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _realAirTimesData(List data) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Color(0xffFFE33F),
                  ),
                  Text(

                    model.appLocale == Locale('en')
                        ? data[index]["name"] == null
                            ? ""
                            : " ${data[index]["name"]}  ${data[index]["from_time"]}  End  ${data[index]["to_time"]} "
                        : " ${data[index]["name"]}  ${data[index]["from_time"]}  End  ${data[index]["to_time"]} ",
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width/25, color: Colors.grey[500]),

                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _uRLface() async {
    String url = widget.data['facebook'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SharedWidget.showSnackBar(
          _scaffoldKeySingleShow, "Could not launch $url");
    }
  }

  _uRLtwitter() async {
    String url = widget.data['twitter'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SharedWidget.showSnackBar(
          _scaffoldKeySingleShow, "Could not launch $url");
    }
  }

  _uRLinsta() async {
    String url = widget.data['instagram'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SharedWidget.showSnackBar(
          _scaffoldKeySingleShow, "Could not launch $url");
    }
  }

  _uRLyoutupe() async {
    String url = widget.data['youtupe'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SharedWidget.showSnackBar(
          _scaffoldKeySingleShow, "Could not launch $url");
    }
  }
}
