import 'dart:typed_data';

//import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:q8_pulse/Data/Models/ThemeModel.dart';
import 'package:q8_pulse/Screens/splash_screen.dart';
import 'package:q8_pulse/utils/app_Localization.dart';
import 'package:q8_pulse/utils/app_LocalizationDeledate.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:q8_pulse/Data/Models/ScopeModelWrapper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter/services.dart' ;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
Future<void> main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  // NOTE: if you want to find out if the app was launched via notification then you could use the following call and then do something like
  // change the default route of the app
  // var notificationAppLaunchDetails =
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload);
      });
  runApp(

  
  ChangeNotifierProvider<ThemeModel>(
        builder: (BuildContext context) => ThemeModel(),
        child: ScopeModelWrapper(),
      ),
      );}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return  ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => MaterialApp(
      
            title: 'Flutter Demo',
           debugShowCheckedModeBanner: false,
            
            // onGenerateTitle: (BuildContext context) =>
            //     DemoLocalizations.of(context).title['title'],
            onGenerateTitle: (BuildContext context) => DemoLocalizations.of(context).title['_language'],
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            
            supportedLocales: [
              Locale("en", ""), // OR Locale('ar', 'AE') OR Other RTL locales
              Locale("ar", ""),
            ],

            locale: model.appLocal,
            theme: Provider.of<ThemeModel>(context).currentTheme,
            home: WillPopScope(
               onWillPop: () {
           //AudioService.disconnect();
          return Future.value(true);
        },
              child: SplashScreen()),
            
          ),
    );
  }
}

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(
      {@required this.id,
        @required this.title,
        @required this.body,
        @required this.payload});
}
Future<void> _scheduleNotification(String programTime , String programName , String programDesc) async {

  var vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
//      icon: 'secondary_icon',
//      sound: 'slow_spring_board',
      largeIcon: 'sample_large_icon',
      largeIconBitmapSource: BitmapSource.Drawable,
      vibrationPattern: vibrationPattern,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500);
  var iOSPlatformChannelSpecifics =
  IOSNotificationDetails(sound: "slow_spring_board.aiff");
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      0,
      programDesc,
      programName,
      programTime as DateTime,
      platformChannelSpecifics);
}




