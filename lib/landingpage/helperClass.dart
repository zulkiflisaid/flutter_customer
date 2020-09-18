import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HelperClass {
  static final flutterLocalNotificationsPlugin1 =
      FlutterLocalNotificationsPlugin(); // make it a static field of the class

  static FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    //print("_backgroundMessageHandler");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print('HelperClass _backgroundMessageHandler data: $data');
      String title = data['title'];
      String message1 = data['message'];

      /* await singleNotification(
                  notifiedTime,
                  "Todo - $message1",
                  "Looks like something intersting you have here...!!!",
                  98123871,  
              );*/
      await _showNotificationWithDefaultSound(title, message1);
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print(
          'HelperClass _backgroundMessageHandler notification: $notification');
    }

    return Future<void>.value();
  }

  static Future _showNotificationWithDefaultSound(
      String title, String message) async {
    var androidPlatformChannelSpecifics1 = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics1 = IOSNotificationDetails();
    var platformChannelSpecifics1 = NotificationDetails(
        androidPlatformChannelSpecifics1, iOSPlatformChannelSpecifics1);
    await localNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics1,
        payload: 'item x');

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '111', 'channel_name', 'channel_description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await localNotificationsPlugin.show(
      0,
      '$title',
      '$message',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
