import 'package:flutter/material.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Data/Models/ScopeModelWrapper.dart';
import 'package:q8_pulse/Screens/single_show_screen.dart';
import 'package:q8_pulse/utils/app_Localization.dart';
import 'package:scoped_model/scoped_model.dart';

class ScheduleCard extends StatefulWidget {
  final Map<String, dynamic> data;
  ScheduleCard({this.data});
  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        String text = model.appLocale == Locale('en')
            ? widget.data['title_en'] == null
                ? ""
                : widget.data['title_en']
            : widget.data['title_ar'] == null
                ? ""
                : widget.data['title_ar'];
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
              left: 8,
              right: 8,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        image: new DecorationImage(
                            image: NetworkImage(
                                ConstantVarable.apiImg + widget.data["image"] ==
                                        null
                                    ? "assets/imgs/broadcaster1.png"
                                    : ConstantVarable.apiImg +
                                        widget.data["image"]),
                            fit: BoxFit.cover)),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,

                              blurRadius:
                                  10.0, // has the effect of softening the shadow
                              spreadRadius:
                                  0.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                -5.0,

                                // vertical, move down 10
                              ),
                            )
                          ],
                          color: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.data['pivot']['from_time'] == null
                                  ? ""
                                  : widget.data['pivot']['from_time'],
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/30, color: Colors.grey[400]),
                            ),
                            Container(
                              height: 4,
                            ),
                            Text(
                              text.length >= 20
                                  ? text.substring(0, 17) + "..."
                                  : text,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/30,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width/25,
                                      height: MediaQuery.of(context).size.height/25,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/imgs/bell.png"))),
                                    ),
                                    onTap: () {},
                                  ),
                                  Container(
                                    width: 4,
                                  ),
                                  Text(
                                    DemoLocalizations.of(context)
                                        .title['_notfy_Me'],
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width/30, color: Color(0xffFFE33F)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleShowScreen(
                  data: widget.data,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
