import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification/chat_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: true,
      provisional: true,
      criticalAlert: true,
      announcement: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  void initLocalNotifications(BuildContext context,RemoteMessage message) async {
    var androidInitializationSettings=const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSettings=const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload){
         handleMessage(context, message);
      }
    );
  }
  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        print(message.data['type'].toString());
        print(message.data['id'].toString());
      }
      if(Platform.isAndroid){
        initLocalNotifications(context, message);
        showNotification(message);
      }
     else{
        showNotification(message);
      }
    });
  }

 Future<void> showNotification(RemoteMessage message) async{

  AndroidNotificationChannel channel=AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'high important notification',
      importance:Importance.max,
  );

  AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'Your channel description',
      importance:Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: "@mipmap/ic_launcher",
  );
  DarwinNotificationDetails darwinNotificationDetails=const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge:true,
    presentSound: true
  );

  NotificationDetails notificationDetails=NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
  );

  Future.delayed(Duration.zero,(){
    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails
    );
  });
  }

  Future<String> getDeviceToken() async{
    String? token= await messaging.getToken();
    return token!;
  }

  Future<void> setupInteractMessage(BuildContext context) async{
    //when app terminate
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }

    //when app is in Background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }
  void handleMessage(BuildContext context,RemoteMessage message){
       if(message.data['type'] == 'message'){
         Navigator.push(context,MaterialPageRoute(builder: (context) =>  ChatMessage(
           id: message.data['id'],
         )));
       }
  }

  void isTokenRefresh(){
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

}
