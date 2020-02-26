// TODO Implement this library.

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsServices {
  final Firestore _db = Firestore();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  /// Get the token, save it to the database for current user
  saveDeviceToken() async {
    // Get the current user
    // String uid = 'jeffd23';
    _fcm.getToken().then((token) {
      print("token is $token");
    });

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      _db.collection('tokens').add({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });

      // await tokens.setData({
      //   'token': fcmToken,
      //   'createdAt': FieldValue.serverTimestamp(), // optional
      //   'platform': Platform.operatingSystem // optional
      // });
    }
  }

  subscribeToTopic(String id) async {
    // Subscribe the user to a topic
    _fcm.subscribeToTopic(id);
  }
}
