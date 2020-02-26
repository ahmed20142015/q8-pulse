import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/Controllers/HomeController.dart';
import 'package:q8_pulse/Controllers/UserController.dart';
import 'package:q8_pulse/Widgets/AppBarWidget.dart';
import 'package:q8_pulse/Widgets/PresenterCard.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';

class AllPresentersScreen extends StatefulWidget {
  bool valueMode;
  int guestId ;
  AllPresentersScreen({this.valueMode , this.guestId});
  createState() => AllPresentersView();
}

class AllPresentersView extends StateMVC<AllPresentersScreen> {
  AllPresentersView() : super(UserController()) {
    _homeController = HomeController.con;
  }

  HomeController _homeController;

  initState() {
    super.initState();
    _homeController.getAllPresenters();
  }



  Widget nullWedgit() {
    return Container(
      width: 25,
      height: 25,
    );
  }

  Widget title() {
    return Text(
      DemoLocalizations.of(context).title['_presenters'],
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.width/25, color:widget.valueMode == false ? Color(0xff585757) : Colors.white ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBarWidget()
                  .showAppBar(context,SharedWidget.arrowBack(), title(), nullWedgit()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: _homeController.getAllPresentersStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print('all presenters has data ');
                    return _realPresentersData(snapshot.data);
                  } else {
                    return _splashPresenters();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _realPresentersData(List data) {
    if(data.length!=0){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,

          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      physics: ClampingScrollPhysics(),
      itemCount: data.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return PresenterCard(
          data: data[index],
          guestId : widget.guestId
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

  Widget _splashPresenters() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
