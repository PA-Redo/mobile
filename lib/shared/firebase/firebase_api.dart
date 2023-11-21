import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;


  Future<void> initNotification(GlobalKey<NavigatorState> navigatorKey) async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    //autorize notif when app closed
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    //see notif when app open

    print('Token: $token');
    FirebaseMessaging.onMessage.listen((message) {
      print('Title: ${message.notification!.title}');
      print('Body: ${message.notification!.body}');
      print('Data: ${message.data}');
      //Open dialog without context
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(message.notification!.body!),
          backgroundColor: Theme.of(navigatorKey.currentContext!).colorScheme.background,
        ),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Title: ${message.notification!.title}');
      print('Body: ${message.notification!.body}');
      print('Data: ${message.data}');
    });
  }
}
