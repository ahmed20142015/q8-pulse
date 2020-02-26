import 'package:flutter/material.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Data/Models/ScopeModelWrapper.dart';
import 'package:q8_pulse/Screens/single_presenter_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class PresenterCard extends StatefulWidget {
  final Map<String, dynamic> data;
  int guestId ;
  PresenterCard({this.data , this.guestId});
  @override
  _PresenterCardState createState() => _PresenterCardState();
}

class _PresenterCardState extends State<PresenterCard> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return InkWell(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                  radius: MediaQuery.of(context).size.width/5,
                  backgroundImage: NetworkImage(
                                ConstantVarable.apiImg + widget.data["image"] ==
                                        null
                                    ? "assets/imgs/broadcaster1.png"
                                    : ConstantVarable.apiImg +
                                        widget.data["image"]),
                ),
                    
                    Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          model.appLocale == Locale('en')
                              ? widget.data["name_en"] == null
                                  ? ""
                                  : widget.data["name_en"]
                              : widget.data["name_ar"] == null
                                  ? ""
                                  : widget.data["name_ar"],
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/25,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500]),
                        ))
                  ],
                ),
              ),
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
        );
      },
    );
  }
}
