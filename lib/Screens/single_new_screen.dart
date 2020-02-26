import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/NewsControllers.dart';
import 'package:q8_pulse/Data/Models/ScopeModelWrapper.dart';
import 'package:q8_pulse/Widgets/AppBarWidget.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;


class SingleNewScreen extends StatefulWidget {
  Map<String , dynamic> data;
  SingleNewScreen({this.data});
  createState() => SingleNewView();
}

class SingleNewView extends StateMVC<SingleNewScreen> {
  Widget arrowBack() {
    return InkWell(
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/imgs/ic_back@3x.png"))),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget share() {
    return InkWell(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/imgs/ic_share@3x.png"),
                fit: BoxFit.cover)),
      ),
      onTap: () {
       NewsController().share(context);
      },
    );
  }

  Widget nullWedgit() {
    return Container(
      width: 25,
      height: 25,
    );
  }

    final GlobalKey<ScaffoldState> _scaffoldKeySingleNew =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKeySingleNew,
      body: SingleChildScrollView(
        child: ScopedModelDescendant<AppModel>(
          builder: (context , child , model){
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                ConstantVarable.apiImg + widget.data["image"]== null ?
                                "assets/imgs/broadcaster1.png" :
                                ConstantVarable.apiImg + widget.data["image"]
                            ),
                            fit: BoxFit.cover)),
                    child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: AppBarWidget().showAppBar(
                                  context, arrowBack(), nullWedgit(), SharedWidget.shareWidget(context, true)),
                            ),

                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      model.appLocale == Locale('en')?
                      widget.data['title_en']:
                      widget.data['title_ar']
                      ,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/25,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32 , left: 12 , right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "by ${widget.data['author_name']} ",
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width/25, color: Color(0xff9C9C9C)),
                        ),
                        Text(
                          widget.data['date2']==null ?
                          "":
                          widget.data['date2'],
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width/25, color: Color(0xff9C9C9C)),
                        ),
                      ],
                    ),
                  ),



                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Html(
                              data: """
    <!--For a much more extensive example, look at example/main.dart-->
    <div>
      <p>${model.appLocale == Locale('en') ?
                              widget.data['content_en'] :
                              widget.data['content_ar']} </p>
     
      <!--You can pretty much put any html in here!-->
    </div>
  """,
                              //Optional parameters:
                              padding: EdgeInsets.all(8.0),
                              backgroundColor: Colors.grey[800],


                              linkStyle: const TextStyle(
                                color: Color(0xffF2C438),
                              ),
                              onLinkTap: (url) {
                                urlContents(url);
                              },
                              onImageTap: (src) {
                                // Display the image in large form.
                              },
                              //Must have useRichText set to false for this to work.


                              customTextStyle: (dom.Node node, TextStyle baseStyle) {
                                if (node is dom.Element) {
                                  switch (node.localName) {
                                    case "h1":
                                      return baseStyle.merge(TextStyle(height: 2, fontSize: MediaQuery.of(context).size.width/25 , color: Colors.grey[500]));
                                    case "p":
                                      return baseStyle.merge(TextStyle(height: 2, fontSize: MediaQuery.of(context).size.width/25 , color: Colors.grey[500]));
                                  }
                                }
                                return baseStyle;
                              },
                            )
                        ),
                      ),
                    ),
                  ),

                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DemoLocalizations.of(context).title['_social_media'],
                          style:
                          TextStyle(fontSize: MediaQuery.of(context).size.width/25 , fontWeight: FontWeight.bold , color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        _scaffoldKeySingleNew,
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
                                        _scaffoldKeySingleNew,
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
                                        _scaffoldKeySingleNew,
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
                                        _scaffoldKeySingleNew,
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

                  Container(height: 50,)
                ],
              ),
            );
          },

        ),
      ),
    );
  }
  _uRLface() async {
    String url = widget.data['facebook'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SharedWidget.showSnackBar(
          _scaffoldKeySingleNew, "Could not launch $url");
    }
  }

  _uRLtwitter() async {
    String url = widget.data['twitter'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SharedWidget.showSnackBar(
          _scaffoldKeySingleNew, "Could not launch $url");
    }
  }

  _uRLinsta() async {
    String url = widget.data['instagram'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SharedWidget.showSnackBar(
          _scaffoldKeySingleNew, "Could not launch $url");
    }
  }

  _uRLyoutupe() async {
    String url = widget.data['youtupe'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SharedWidget.showSnackBar(
          _scaffoldKeySingleNew, "Could not launch $url");
    }
  }

  urlContents(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SharedWidget.showSnackBar(
          _scaffoldKeySingleNew, "Could not launch $url");
    }
  }



}
