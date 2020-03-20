import 'package:flutter/material.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Data/Models/ScopeModelWrapper.dart';
import 'package:q8_pulse/Screens/single_new_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class NewsCard extends StatefulWidget {
  @override
  final Map<String, dynamic> data;
  NewsCard({this.data});
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context,child,model){
return Padding(
        padding: const EdgeInsets.only(bottom: 8 , left: 8 , right: 8),
        child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                                   ConstantVarable.apiImg + widget.data["image"]== null ?
                                   "assets/imgs/broadcaster1.png" :
                                  ConstantVarable.apiImg + widget.data["image"]
                                   ), fit: BoxFit.cover),

                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12) , topRight: Radius.circular(12))
                        ),

          ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius:
                              20.0, // has the effect of softening the shadow
                              spreadRadius:
                              5.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                -5.0,

                                // vertical, move down 10
                              ),
                            )
                          ],


                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12) , bottomRight: Radius.circular(12))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: <Widget>[
                            Text(
                              widget.data['date2']== null ?
                              "":
                              widget.data['date2'],
                              style: TextStyle( fontSize: MediaQuery.of(context).size.width/30, color: Colors.white),
                            ),
                            Text(
                              model.appLocale==Locale('en')?
                              widget.data['title_en']== null ?
                              "":
                              widget.data['title_en']:
                              widget.data['title_ar']== null ?
                              "":
                              widget.data['title_ar']
                              ,
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width/30 , fontWeight: FontWeight.w500 , color: Colors.white ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => SingleNewScreen(
              data: widget.data,
              )
            ));
          },
        ),
      );
      },
          
    );
  }
}
