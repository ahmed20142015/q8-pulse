import 'package:flutter/material.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Screens/single_Presenter_picture.dart';

class GallaryCard extends StatefulWidget {
  final Map<String, dynamic> data;
  GallaryCard({this.data});
  @override
  _GallaryCardState createState() => _GallaryCardState();
}

class _GallaryCardState extends State<GallaryCard> {
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(ConstantVarable.apiImg + widget.data["image"]== null ? 
                             "assets/imgs/broadcaster1.png" :
                            ConstantVarable.apiImg + widget.data["image"]),fit: BoxFit.cover )
        ),
        
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
builder: (context) => PresenterPicture(
  data: widget.data,
)
        ));
      },
    );
  }
}