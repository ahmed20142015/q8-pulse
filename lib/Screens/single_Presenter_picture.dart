
import 'package:flutter/material.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:photo_view/photo_view.dart';

class PresenterPicture extends StatefulWidget {
 Map <String , dynamic> data;
 PresenterPicture({this.data});
  @override
  _PresenterPictureState createState() => _PresenterPictureState();
}

class _PresenterPictureState extends State<PresenterPicture> {

      Widget arrowBack() {
      return InkWell(
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/imgs/ic_back@3x.png"))),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      );
    }

    Widget nullWedgit() {
      return Container(
        width: 25,
        height: 25,
      );
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
backgroundColor:Color(0xff2B2B2B),
      ),

      body: Center(
              child: Container(
                child: PhotoView(
                  imageProvider: NetworkImage(
                      ConstantVarable.apiImg + widget.data["image"]== null ?
                      "assets/imgs/broadcaster1.png" :
                      ConstantVarable.apiImg + widget.data["image"]
                  ),
                ),
        
    ),
      ),
    );
  }
}