import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/Controllers/NewsControllers.dart';
import 'package:q8_pulse/Widgets/AppBarWidget.dart';
import 'package:q8_pulse/Widgets/NewsCard.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';

class AllNewsScreen extends StatefulWidget {
  bool valueMode;
  AllNewsScreen({this.valueMode});
  createState() => AllNewsView();
}

class AllNewsView extends StateMVC<AllNewsScreen> {
  AllNewsView() : super(NewsController()) {
    _newsController = NewsController.con;
  }

  NewsController _newsController;

   initState(){
    
      print("hello News Screen");
      _newsController.getAllNews();
        super.initState();
    }



  Widget title() {
    return Text(
      DemoLocalizations.of(context).title['_news'],
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width/25,
       color:widget.valueMode == false ? Color(0xff585757) : Colors.white 
      ),
    );
  }

  Widget nullWedgit() {
    return Container(
      width: 30,
      height: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBarWidget()
                .showAppBar(context, SharedWidget.arrowBack(), title(), nullWedgit()),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
           
           
            StreamBuilder(
                  stream: _newsController.getAllNewsStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print('news has data ');
                      return _realNewsData(snapshot.data);
                    } else {
                      return _splashNews();
                    }
                  },
                ),
          ],
        ),
      ),
    );
  }

      Widget _realNewsData(List data) {
        if(data.length != 0){
    return    ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return NewsCard(
                  data: data[index],

                );
              },
            );}else{
               return Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/imgs/empty.png"),
                  fit: BoxFit.cover)),
        ),
      );
            }
  }

  Widget _splashNews() {
    return Center(child: CircularProgressIndicator(),);
  }
}
