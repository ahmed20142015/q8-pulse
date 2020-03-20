import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';
import 'package:q8_pulse/Controllers/UserLocalStorage.dart';
import 'package:q8_pulse/Data/Models/NotificationModel.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
      'chnnel id', 'channel name', 'channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: false,
      autoCancel: false);
  final iosChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
}

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    _showNotifivaction(notifications, title: title, body: body, type: _ongoing);

Future _showNotifivaction(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);

Future<void> scheduleNotification(
  FlutterLocalNotificationsPlugin notifications, {
  String timeProgram,
  @required String title,
  @required String body,
  int id = 0,
}) async {
  var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 7));
  await notifications.schedule(
      0, title, body, scheduledNotificationDateTime, _ongoing);
//  _showNotifivaction(notifications, title: title, body: body, type: _ongoing);
}

Future<void> showWeeklyAtDayAndTime(
  int id,
  String title,
  String body,
  String dayFromBack,
  String notificationTime,

) async {
  String hour = notificationTime.substring(1,2);
  String minute = notificationTime.substring(3,5);
  String second = notificationTime.substring(6,8);
  int hourInt = int.parse(hour);
  int minuteInt = int.parse(minute);
  int secondInt = int.parse(second);
  print(hourInt);
  print(minuteInt);
  print(secondInt);
  var time = Time(hourInt, minuteInt , secondInt);
  int day;
  var realDay = Day(day);
  switch(dayFromBack) {
    case "Sunday": {
      day = 1 ;
    }
    break;
    case "Monday": {
      day = 2 ;
    }
    break;

    case "Tuesday": {
      day = 3 ;
    }
    break;
    case "Wednsday": {
      day = 4 ;
    }
    break;
    case "Thursday": {
      day = 5 ;
    }
    break;

    case "Friday": {
      day = 6 ;
    }
    break;

    case "Saturday": {
      day = 7 ;
    }
    break;

    default: {
     day = 0 ;
    }
    break;
  }
  var androidPlatformChannelSpecifics =
      AndroidNotificationDetails('$id', '$title', '$body');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      id, '$title',
      '$body',
      realDay ,
      time ,
      platformChannelSpecifics).then((done){
       print("notification is done");
//       UserLocalStorage().saveNotifications$id(id , notified );

  });
}

Future<void> cancelNotification(int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
  print("notification is cancled");
}
Future<List<int>> checkPendingNotificationRequests(BuildContext context ) async {
  var pendingNotificationRequests =
  await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  List<int> listId = List();

  for (int i = 0 ; i < pendingNotificationRequests.length ; i++) {

    debugPrint(
        'pending notification: [id: ${pendingNotificationRequests[i].id},'
            ' title: ${pendingNotificationRequests[i].title},'
            ' body: ${pendingNotificationRequests[i].body},'
            ' payload: ${pendingNotificationRequests[i].payload}]');
    listId.add(pendingNotificationRequests[i].id);


  }
  print(listId);
  return listId;
}


