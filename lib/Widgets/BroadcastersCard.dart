import 'package:flutter/material.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Data/Models/ScopeModelWrapper.dart';
import 'package:q8_pulse/Screens/single_presenter_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class BroadcastersCard extends StatefulWidget {
  int position;
  int guestId ;
  final Map<String, dynamic> data;
  BroadcastersCard({this.position, this.data , this.guestId});
  @override
  _BroadcastersCardState createState() => _BroadcastersCardState();
}

class _BroadcastersCardState extends State<BroadcastersCard> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          child: Container(
           
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width/12,
                  backgroundImage: NetworkImage(
                      ConstantVarable.apiImg + widget.data["image"] == null
                          ? "assets/imgs/broadcaster1.png"
                          : ConstantVarable.apiImg + widget.data["image"]),
                ),
                // Text(
                //   model.appLocale == Locale('en')
                //       ? widget.data["name_en"] == null
                //           ? ""
                //           : widget.data["name_en"]
                //       : widget.data["name_ar"] == null
                //           ? ""
                //           : widget.data["name_ar"],
                //   style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                // )
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SinglePresenterScreen(
                          dataPresenter: widget.data,
                      guestId: widget.guestId,
                        )));
          },
        ),
      );
    });
  }
}
