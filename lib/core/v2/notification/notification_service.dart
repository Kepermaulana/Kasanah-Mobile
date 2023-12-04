// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//   "1",
//   "2",
// );

// NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);

// class NotificationService {
//   static final NotificationService _notificationService =
//       NotificationService._internal();

//   factory NotificationService() {
//     return _notificationService;
//   }

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   NotificationService._internal();

//   Future<void> init() async {
//     // ignore: prefer_const_declarations
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('@drawable/notif_image');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> show(int notifId, String title, String body,
//       {String payload: "data"}) async {
//     await flutterLocalNotificationsPlugin
//         .show(notifId, title, body, platformChannelSpecifics, payload: payload);
//   }
// }
