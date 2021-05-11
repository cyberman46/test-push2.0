import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test_push/pushnotification.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  int _totalNotifications;
  PushNotification _notificationInfo;

  Future<dynamic> _firebaseMessagingBackgroundHandler(
    Map<String, dynamic> message,
  ) async {
    // Initialize the Firebase app
    await Firebase.initializeApp();
    print('onBackgroundMessage received: $message');
  }

  void notificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void initMessage() {
    var androiInit = AndroidInitializationSettings('ic_luancher');
    var iosInit = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initSetting);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification();
    });
  }

  Future<void> showNotification() async {
    var androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription');
    var iosDetals = IOSNotificationDetails();
    var generalDetials =
        NotificationDetails(android: androidDetails, iOS: iosDetals);
    await flutterLocalNotificationsPlugin
        .show(0, 'title', 'body', generalDetials, payload: 'Notification');
  }

  void getToken() {
    _messaging.getToken().then((String token) async {
      assert(token != null);
      print(token);
    });
  }

  @override
  void initState() {
    _totalNotifications = 0;
    notificationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            onPressed: () async {
              await _messaging.subscribeToTopic('sendnotification');
            },
            child: Text("Subscribe to topic"),
          ),
          MaterialButton(
            onPressed: () async {
              await _messaging.subscribeToTopic('sendnotification');
            },
            child: Text("Unsubscribe to topic"),
          )
        ],
      ),
    );
  }
}
