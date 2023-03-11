import 'package:flutter/material.dart';

import 'notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    //notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print('value');
      print(value);
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen(Firebase Notification)'),
      ),
       body:  Center(
        child: Text('Flutter Firebase Notification',
          textAlign: TextAlign.center,
          style: TextStyle(
          fontSize: 30,
          color: Colors.lightBlue,
          fontWeight: FontWeight.bold,
        ),),
      ),
    );
  }
}
