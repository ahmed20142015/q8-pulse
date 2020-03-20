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

class AboutScreen extends StatefulWidget {
  createState() => AboutView();
}

class AboutView extends StateMVC<AboutScreen> {


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
          builder: (context, child, model) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height/3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/imgs/about.jpg"),fit: BoxFit.cover)
              ),
              child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: AppBarWidget().showAppBar(
                            context, SharedWidget.arrowBack(), nullWedgit(), nullWedgit()),
                      ),

                    ],
                  )),
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
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8 , bottom: 8),
                                child: Text(DemoLocalizations.of(context)
                                    .title['_about1'] ,
                                style: TextStyle(fontSize: MediaQuery.of(context).size.width/25 ,),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8 , bottom: 8),
                                child: Text(DemoLocalizations.of(context)
                                    .title['_about2'],
                                    style: TextStyle(fontSize: MediaQuery.of(context).size.width/25 ,)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8 , bottom: 8),
                                child: Text(DemoLocalizations.of(context)
                                    .title['_about2'],
                                    style: TextStyle(fontSize: MediaQuery.of(context).size.width/25 ,)),
                              )
                            ],
                          )),
                    ),
                  ),
                ),

              ],
            );
          },
        ),
      ),
    );
  }
}
