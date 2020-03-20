import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/ShowsController.dart';
import 'package:q8_pulse/Controllers/UserLocalStorage.dart';
import 'package:q8_pulse/Data/Models/ScopeModelWrapper.dart';
import 'package:q8_pulse/Screens/single_show_screen.dart';
import 'package:q8_pulse/Services/Notifications.dart';
import 'package:q8_pulse/Widgets/local_notification_helper.dart';
import 'package:q8_pulse/utils/app_Localization.dart';
import 'package:scoped_model/scoped_model.dart';



class ShowsCard extends StatefulWidget {

  final Map<String, dynamic> data;
  bool valueMode;
  List<int> listNotificationsId;
  bool notifyOrNo;
  int guestId;



  ShowsCard({this.data, this.valueMode, this.listNotificationsId , this.guestId});
  @override
  _ShowsCardState createState() => _ShowsCardState();
}

class _ShowsCardState extends State<ShowsCard> {
  final notifications = FlutterLocalNotificationsPlugin();


  Widget activeNotifications(int id) {
    print("Active $id");
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width/25,
              height: MediaQuery.of(context).size.height/25,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        widget.notifyOrNo!=false?
                      "assets/imgs/bellActive.png":
                        "assets/imgs/bell.png"
                      )),),
            ),
            Container(
              width: 4,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                DemoLocalizations.of(context).title['_notfy_Me'],
                style: TextStyle(fontSize: MediaQuery.of(context).size.width/20, color:widget.notifyOrNo!=false?
                Color(0xffFFE33F):
                    Colors.grey[500]
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
if(widget.notifyOrNo==false){
  cancelNotification(widget.data["id"]);
  setState(() {
    widget.notifyOrNo = true ;
  });

}else{
  ShowsController()
      .getAirTimes2(widget.data["id"].toString())
      .then((daysList) {

    setState(() {
      widget.notifyOrNo = false ;
    });

    ShowsController()
        .getAirTimes(widget.data["id"].toString())
        .then((listTimes) {
      for (int index = 0; index < listTimes.length; index++) {
        showWeeklyAtDayAndTime(
          widget.data["id"],
          widget.data["title_en"],
          widget.data["description2_en"],
          daysList[index],
          listTimes[index],
        );
      }
    });
  });
}

      },
    );
  }

  Widget disActiveNotifications(int id) {
    print("deActive $id");
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          children: <Widget>[
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          widget.notifyOrNo!=false?
                      "assets/imgs/bell.png":
                          "assets/imgs/bellActive.png"

                      ))),
            ),
            Container(
              width: 4,
            ),
            Text(
              DemoLocalizations.of(context).title['_notfy_Me'],
              style: TextStyle(fontSize: 15, color:
              widget.notifyOrNo!=false?
              Colors.grey[500]:
              Color(0xffFFE33F)

              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if(widget.notifyOrNo!=false){
          cancelNotification(widget.data["id"]);
          setState(() {
            widget.notifyOrNo = false ;
          });

        }else{
          ShowsController()
              .getAirTimes2(widget.data["id"].toString())
              .then((daysList) {

            setState(() {
              widget.notifyOrNo = true ;
            });

            ShowsController()
                .getAirTimes(widget.data["id"].toString())
                .then((listTimes) {
              for (int index = 0; index < listTimes.length; index++) {
                showWeeklyAtDayAndTime(
                  widget.data["id"],
                  widget.data["title_en"],
                  widget.data["description2_en"],
                  daysList[index],
                  listTimes[index],
                );
              }
            });
          });
        }


      },
    );
  }

  Widget notificationWidget() {
    // yield
    // map<//filtertion>
    // save data shared pref set ,, get
//    var a = [1, 2, 3, 4, 5];
//    var res = () sync* { for (var v in a) if (v > 2) yield v; } ();

//widget.listNotificationsId.forEach((f){
//  if(widget.data['id']!= f ) {
//   // print("active $f");
//    return activeNotifications(f);
//
//  }else{
//    return disActiveNotifications(f);
//  }
//});


      for(int x = 0 ; x < widget.listNotificationsId.length ; x++){
        print("==== ${widget.listNotificationsId.length}");
        print("==== ${widget.listNotificationsId.toList()}");
        if (widget.listNotificationsId[x]!=widget.data['id']) {
          return activeNotifications(widget.listNotificationsId[x]);
        } else{
          return disActiveNotifications(widget.listNotificationsId[x]);
        }
      }

//      int i = 0 ;
//
//     while(i<widget.listNotificationsId.length){
//       if (widget.listNotificationsId[i]!=widget.data['id']) {
//         return activeNotifications();
//       } else{
//         return disActiveNotifications();
//       }
//     }



  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        String text = model.appLocale == Locale('en')
            ? widget.data['title_en']
            : widget.data['title_ar'];
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.height/2,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          image: new DecorationImage(
                              image: NetworkImage(ConstantVarable.apiImg +
                                          widget.data["image"] ==
                                      null
                                  ? "assets/imgs/broadcaster1.png"
                                  : ConstantVarable.apiImg +
                                      widget.data["image"]),
                              fit: BoxFit.cover)),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "9:30 am",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
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
                          color: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(text==null?"":
                              text.length >= 20
                                  ? text.substring(0, 12) + "..."
                                  : text,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/25, color: Colors.grey[500]),
                            ),
                            notificationWidget(),
                          ],
                        ),
                      ),
                    ),

                ],
              ),
            ),
          ),
          onTap: () {
            UserLocalStorage().getUser().then((user) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleShowScreen(
                            data: widget.data,
                            valueMode: widget.valueMode,
                            phone: user.phone,
                        guestId:widget.guestId
                          )));
            });
          },
        );
      },
    );
  }
  Future<void> dialogNotifiedOrNo(BuildContext context) async {
    // check if 0 skill , 1 history , 2 education

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '? Are you sure you want to sign out',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: InkWell(
                    child: new Container(
                      width: MediaQuery.of(context).size.width / 2.8,
                      child: new Material(
                          color: const Color(0xffA71E26),
                          elevation: 0.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                              side:
                              BorderSide(color: Colors.white, width: 2.0)),
                          child: new Center(
                              child: new Padding(
                                  padding: new EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: new Text(
                                    "Yas",
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 15.0),
                                  )))),
                    ),
                    onTap: () {
//                      UserLocalStorage().clear();
//                      Navigator.pushReplacement(context,new MaterialPageRoute(
//                          builder: (BuildContext context) => Login1Screen()));


                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: InkWell(
                    child: new Container(
                      width: MediaQuery.of(context).size.width / 2.8,
                      child: new Material(
                          color: const Color(0xffA71E26),
                          elevation: 0.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                              side:
                              BorderSide(color: Colors.white, width: 2.0)),
                          child: new Center(
                              child: new Padding(
                                  padding: new EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: new Text(
                                    "Cancel",
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 15.0),
                                  )))),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

}
