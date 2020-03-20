import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/Controllers/GalleryController.dart';
import 'package:q8_pulse/Widgets/AppBarWidget.dart';
import 'package:q8_pulse/Widgets/GallaryCard.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';

class GalaryScreen extends StatefulWidget {
  bool valueMode;
  GalaryScreen({this.valueMode});
  createState() => GalaryView();
}

class GalaryView extends StateMVC<GalaryScreen> {
  GalaryView() : super(GalleryController()) {
    _galleryController = GalleryController.con;
  }
  GalleryController _galleryController;

   initState(){
      super.initState();

      _galleryController.getGallery();
    }
  @override
  Widget build(BuildContext context) {
    Widget title() {
      return Text(
        DemoLocalizations.of(context).title['_gallary'],
        style: TextStyle(fontSize: MediaQuery.of(context).size.width/25,
        color:widget.valueMode == false ? Color(0xff585757) : Colors.white 
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
      appBar:  AppBarWidget()
                .showAppBar(context,SharedWidget.arrowBack(), title(), nullWedgit()),
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
         
           StreamBuilder(
                    stream: _galleryController.getGalleryStream.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print('gallery has data ');
                        return _realGalleryData(snapshot.data);
                      } else {
                        return _splash();
                      }
                    },
                  ),
        ],
      ),
    ));
  }
    Widget _realGalleryData(List data) {
      if(data.length!=0){
    return  GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                
                // childAspectRatio: 0.6,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0),
            physics: ClampingScrollPhysics(),
            itemCount: data.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GallaryCard(
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

  Widget _splash() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
