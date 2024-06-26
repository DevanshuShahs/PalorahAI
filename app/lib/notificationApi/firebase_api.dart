import 'package:app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  //prints notification to console. Can be deleted later
  print(message.notification?.title);
  print(message.notification?.body);
  print(message.data);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    //navigates to new page and passes message as parameter. **Add optional paramter to the recipent page when using**
    if (message == null) return;

    //  navigatorKey.currentState?.push(
    //     CupertinoPageRoute(
    //       builder: (context) => homePage(notificationMessage: message), //**change route of notification later to whichever page needs to be opened**
    //     ),
    //   );
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(
        handleMessage); //when app is terminated (closed out) and clicked on
    FirebaseMessaging.onMessageOpenedApp
        .listen(handleMessage); //when app is in background and is clicked on
    FirebaseMessaging.onBackgroundMessage(
        handleBackgroundMessage); //when notification is recieived while app is background or terminated
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("Token: $fCMToken");
    initPushNotifications();
  }
}
