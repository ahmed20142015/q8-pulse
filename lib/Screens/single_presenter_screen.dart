import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/HomeController.dart';
import 'package:q8_pulse/Controllers/UserLocalStorage.dart';
import 'package:q8_pulse/Data/Models/ScopeModelWrapper.dart';
import 'package:q8_pulse/Screens/single_Presenter_picture.dart';
import 'package:q8_pulse/Screens/single_show_screen.dart';
import 'package:q8_pulse/Widgets/AppBarWidget.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

class SinglePresenterScreen extends StatefulWidget {
 final Map<String, dynamic> dataPresenter;
 bool valueMode ;
 int guestId ;
  SinglePresenterScreen({this.dataPresenter , this.valueMode , this.guestId});
  createState() => SinglePresenterView();
}

class SinglePresenterView extends StateMVC<SinglePresenterScreen> {

  SinglePresenterView():super(HomeController()){
_homeController = HomeController.con;
  }

  HomeController _homeController;

  initState(){
    super.initState();
_homeController.getAllShowsForPresenter(widget.dataPresenter['id'].toString());
    
  }


  Widget nullWedgit() {
    return Container(
      width: 25,
      height: 25,
    );
  }
    final GlobalKey<ScaffoldState> _scaffoldKeySinglePresenter =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeySinglePresenter,
      appBar:  AppBarWidget()
                  .showAppBar(context,SharedWidget.arrowBack(), nullWedgit(), nullWedgit()),
      body: ScopedModelDescendant<AppModel>(
        builder: (context,child,model){
          return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                  
               
                InkWell(
                  child:  CircleAvatar(
                  radius: MediaQuery.of(context).size.width/5,
                  backgroundImage: NetworkImage( ConstantVarable.apiImg + widget.dataPresenter["image"]== null ? 
                               "assets/imgs/broadcaster1.png" :
                              ConstantVarable.apiImg + widget.dataPresenter["image"]),
                ),
                  onTap: () {
                   
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PresenterPicture(
                              data: widget.dataPresenter,
                            )));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                   model.appLocale == Locale('en')
                                ? widget.dataPresenter["name_en"] == null
                                    ? ""
                                    : widget.dataPresenter["name_en"]
                                : widget.dataPresenter["name_ar"] == null
                                    ? ""
                                    : widget.dataPresenter["name_ar"],
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width/23, fontWeight: FontWeight.bold,color: Colors.grey[500]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 18, top: 16, bottom: 16),
                      child: Column(
                        children: <Widget>[
                        
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Html(
                              data: """
    <!--For a much more extensive example, look at example/main.dart-->
    <div>
      <p> ${
                                                          model.appLocale==Locale('en')?
                               widget.dataPresenter["about2_en"]==null ?
                               "":
                               widget.dataPresenter["about2_en"]:
                                 widget.dataPresenter["about2_ar"]==null ?
                               "":
                               widget.dataPresenter["about2_ar"]

                              }</p>

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
                                      return baseStyle.merge(TextStyle(height: 2, fontSize: MediaQuery.of(context).size.width/25, color: Colors.grey[500]));
                                  }
                                }
                                return baseStyle;
                              },
                            )
//                            Text(model.appLocale==Locale('en')?
//                               widget.dataPresenter["about2_en"]==null ?
//                               "":
//                               widget.dataPresenter["about2_en"]:
//                                 widget.dataPresenter["about2_ar"]==null ?
//                               "":
//                               widget.dataPresenter["about2_ar"]
//                               ,
//                              style:
//                                  TextStyle(fontSize: 15, color: Colors.grey[500]),
//                            ),

                          ),
                        
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                       DemoLocalizations.of(context).title['_my_shows'],
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/23, fontWeight: FontWeight.bold,color: Colors.grey[500]),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: <Widget>[

                          StreamBuilder(
                    stream: _homeController.getAllShowsForPresenterStream.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print('all Shows for presenter data ');
                        return _realPresenterShowsData(snapshot.data);
                      } else {
                        return _splashPresenterShowsData();
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
                Row(
                  children: <Widget>[
                    Text(
                      DemoLocalizations.of(context).title['_find_me_on_social_media'],
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/25, fontWeight: FontWeight.bold,color: Colors.grey[500]),
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
                                      if (widget.dataPresenter['facebook'] == null) {
                                        SharedWidget.showSnackBar(
                                            _scaffoldKeySinglePresenter,
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
                                         if (widget.dataPresenter['twitter'] == null) {
                                        SharedWidget.showSnackBar(
                                            _scaffoldKeySinglePresenter,
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
                                        if (widget.dataPresenter['instagram'] == null) {
                                        SharedWidget.showSnackBar(
                                            _scaffoldKeySinglePresenter,
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
                                        if (widget.dataPresenter['youtupe'] == null) {
                                        SharedWidget.showSnackBar(
                                            _scaffoldKeySinglePresenter,
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
        );
        },       
      ),
    );
  }

  Future<void> _dialogPicPresenter(BuildContext context) async {
    // check if 0 skill , 1 history , 2 education
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/imgs/shutterstock_-13.png"),
                      fit: BoxFit.cover)),
            ),
          ],
        );
      },
    );
  }
  _uRLface() async {
    String url = widget.dataPresenter['facebook'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SharedWidget.showSnackBar(
          _scaffoldKeySinglePresenter, "Could not launch $url");
    }
  }

  _uRLtwitter() async {
    String url = widget.dataPresenter['twitter'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SharedWidget.showSnackBar(
          _scaffoldKeySinglePresenter, "Could not launch $url");
    }
  }

  _uRLinsta() async {
    String url = widget.dataPresenter['instagram'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SharedWidget.showSnackBar(
          _scaffoldKeySinglePresenter, "Could not launch $url");
    }
  }

  _uRLyoutupe() async {
    String url = widget.dataPresenter['youtupe'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
         SharedWidget.showSnackBar(
          _scaffoldKeySinglePresenter, "Could not launch $url");
    }
  }

  Widget _realPresenterShowsData(List data) {
    return   ScopedModelDescendant<AppModel>(
      builder: (context,child,model){
        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 8, right: 8),
                                      child: CircleAvatar(
                                        radius: 5,
                                        backgroundColor: Color(0xffFFE33F),
                                      ),
                                    ),
                                    Text(model.appLocale==Locale('en')?
                                      data[index]['title_en']:
                                      data[index]['title_ar']
                                      ,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width/25,
                                          color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: (){
                                UserLocalStorage().getUser().then((user){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SingleShowScreen(
                                            data: data[index],
                                            valueMode: widget.valueMode,
                                            phone: user.phone,
                                            guestId: widget.guestId,
                                          )));
                                });
                              },
                            );
                          },
                        );
      },
          
    );
  }

  Widget _splashPresenterShowsData() {
    return Center(child: CircularProgressIndicator(),);
  }
}
