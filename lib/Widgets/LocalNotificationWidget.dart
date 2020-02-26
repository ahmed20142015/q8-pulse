

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:q8_pulse/Screens/secound_screen.dart';
import 'package:q8_pulse/Widgets/local_notification_helper.dart';


class LocalNotificationWidget extends StatefulWidget {
  @override
  _LocalNotificationWidgetState createState() => _LocalNotificationWidgetState();
}

class _LocalNotificationWidgetState extends State<LocalNotificationWidget> {
  final notifications = FlutterLocalNotificationsPlugin();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future onSelectNotification(String payload) async {
      return Navigator.push(context,
          MaterialPageRoute(
              builder: (context)=> SecondScreen(payload: payload) ));
    }
    final settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settingsIos = IOSInitializationSettings(
      onDidReceiveLocalNotification: (id , title , body , payload) =>
          onSelectNotification(payload)
    );
    notifications.initialize(
      InitializationSettings(settingsAndroid, settingsIos),
      onSelectNotification: onSelectNotification
    );

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Text("basics"),
          RaisedButton(
            child: Text("show notification"),
              onPressed: (){
showOngoingNotification(notifications , title: "khaled" , body: "this Global");
          })
        ],
      ),
    );
  }
}


