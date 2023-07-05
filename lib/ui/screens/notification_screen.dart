import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plant/constants.dart';
import 'package:plant/ui/root_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  DateTime morningTime = DateTime.now(); // Default morning time
  DateTime eveningTime = DateTime.now();
  NotificationsServices notificationsServices = NotificationsServices();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    notificationsServices.initializeNotifications();
    notificationsServices.setNotificationHandler(context);
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        const InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    tz.initializeTimeZones();
  }

  Future<void> schedulePlantWateringNotifications() async {
    const morningNotificationDetails = AndroidNotificationDetails(
      'channel_id_morning',
      'Morning Notifications',
      importance: Importance.max,
    );

    const eveningNotificationDetails = AndroidNotificationDetails(
      'channel_id_evening',
      'Evening Notifications',
      importance: Importance.defaultImportance,
    );

    final morningScheduledDateTime = tz.TZDateTime(
      tz.local,
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      morningTime.hour,
      morningTime.minute,
    );

    final eveningScheduledDateTime = tz.TZDateTime(
      tz.local,
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      eveningTime.hour,
      eveningTime.minute,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Water your plants!',
      'It\'s time to water your plants.',
      morningScheduledDateTime,
      const NotificationDetails(android: morningNotificationDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Water your plants!',
      'It\'s time to water your plants.',
      eveningScheduledDateTime,
      const NotificationDetails(android: eveningNotificationDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    log('Scheduled morning notification at $morningScheduledDateTime');
  }

  @override
  Widget build(BuildContext context) {
    // Default evening time

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.blueGrey,
              ),
            ),
            Text(
              'Schedule Notification',
              style: TextStyle(
                color: Colors.blueGrey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Morning Time'),
              subtitle: Text("${morningTime.hour}:${morningTime.minute}"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueGrey),
                onPressed: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(morningTime),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      morningTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Evening Time'),
              subtitle: Text("${eveningTime.hour}:${eveningTime.minute}"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueGrey),
                onPressed: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(eveningTime),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      eveningTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Constants.primaryColor),
              ),
              onPressed: () {
                NotificationsServices().sendNofication("title", "body");
              },
              child: const Text('Schedule Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationsServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Permission

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  void initializeNotifications() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(android: _androidInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> setNotificationHandler(BuildContext context) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'channel id', 'channel title',
        importance: Importance.max,
        description:
            "descriptiona asdf sdf lorem ipsum lorem ipsum lorem ipsum");

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher')),
    );
  }

  void sendNofication(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel id',
      'channel title',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = const NotificationDetails(
      android: androidNotificationDetails,
    );

    // await _flutterLocalNotificationsPlugin.show(
    //   0,
    //   title,
    //   body,
    //   notificationDetails,
    //   payload: 'payload',
    // );
    tz.initializeTimeZones();
    final tz.Location timeZone = tz.getLocation('Asia/Kolkata');
    final tz.TZDateTime scheduledDateTime = tz.TZDateTime(
      timeZone,
      DateTime.now().year, // Use the current year
      DateTime.now().month, // Use the current month
      DateTime.now().day, // Use the current day
      6, // Set the desired hour (06:00 AM)
      23, // Set the desired minute (06:15 AM)
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Water your plants!',
      'It\'s time to water your plants.',
      scheduledDateTime,
      const NotificationDetails(android: androidNotificationDetails),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidAllowWhileIdle: true,
      payload: 'payload',
    );

    log(scheduledDateTime.toString());
  }
}
