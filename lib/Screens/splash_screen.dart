import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/UserLocalStorage.dart';
import 'package:q8_pulse/Screens/bubbles.dart';
import 'package:q8_pulse/Screens/onboarding_1_screen.dart';
import 'package:q8_pulse/Screens/verification_code_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:q8_pulse/Services/Notifications.dart';




class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final Firestore _db = Firestore();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
  @override
  void initState() {
    super.initState();
//    if (Platform.isIOS) {
//      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
//        print(data);
//
//
//       NotificationsServices().saveDeviceToken();
//      });
//
//      _fcm.requestNotificationPermissions(IosNotificationSettings());
//    } else {
//      NotificationsServices().saveDeviceToken();
//    }

       _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // final snackbar = SnackBar(
        //   content: Text(message['notification']['title']),
        //   action: SnackBarAction(
        //     label: 'Go',
        //     onPressed: () => null,
        //   ),
        // );

        // Scaffold.of(context).showSnackBar(snackbar);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                ),
                actions: <Widget>[
                  FlatButton(
                    color: Colors.amber,
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );


    Timer(Duration(seconds: 3), () {

UserLocalStorage().getUser().then((user){
print("phone is" + user.phone.toString());
setState(() {
  ConstantVarable.constantLang= user.lang;
});

print("hello lang" + ConstantVarable.constantLang.toString());
if(user.phone == null ){
UserLocalStorage().getGoogleName().then((googleInfo){
  
if(googleInfo[2]!=null){
  print(" google or facebook information "+googleInfo.toString());
  Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) => BubblesScreen(
          googleInfo: googleInfo,
          userId: user.id,
        )),
        (Route<dynamic> route) => false,);
}else{
 

  UserLocalStorage().getFacebookInfo().then((faceInfo){
if(faceInfo[2]!=null){
  print(" google or facebook information "+googleInfo.toString());
  Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) => BubblesScreen(
          googleInfo: googleInfo,
          userId: user.id,
        )),
        (Route<dynamic> route) => false,);
}else{
  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (BuildContext context) => Onboarding1Screen(

      )));
}
  });

}
});
  
}else{
  if(user.is_verified==0){
     print(" user is not verified ");
    ConstantVarable.constantLang = user.lang;
 Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => VerificationCodeScreen(
            phone: user.phone,
          )));
  }else{

     print(" user phone is "+user.phone.toString());
    ConstantVarable.constantLang = user.lang;
 Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) => BubblesScreen(
            phone: user.phone,
            firstName:user.first_name,
            lastName:user.last_name,
            userImage: user.image,
            userId: user.id,
          )),
       (Route<dynamic> route) => false,);
         
  }
  
}


});

   
    });
  }

  static loading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
           decoration: BoxDecoration(
                        color: Colors.white,
                       image: DecorationImage(
                         image: AssetImage(
                           "assets/imgs/Splash-Amended.png"
                         ),fit: BoxFit.cover
                       )
                      ),
          
        ));
  }


}
