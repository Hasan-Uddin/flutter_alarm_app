import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init(
    void Function(NotificationResponse) onDidReceiveNotificationResponse,
  ) async {
    await Permission.notification.request();
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    final AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'alarm_channel', // id
      'Alarm Channel', // title
      description: 'Channel for alarm notifications', // description
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('alarm'),
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> showAlarmNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Channel',
      channelDescription: 'Channel for alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      actions: [
        AndroidNotificationAction(
          'stop_alarm',
          'Stop',
          cancelNotification: true,
        ),
      ],
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: 'stop_alarm',
    );
  }

  Future<void> scheduleAlarm(
    int id,
    String title,
    String body,
    DateTime scheduledTime,
  ) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Channel',
          channelDescription: 'Channel for alarm notifications',
          importance: Importance.max,
          priority: Priority.high,
          actions: [
            AndroidNotificationAction(
              'stop_alarm',
              'Stop',
              cancelNotification: true,
            ),
          ],
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllAlarms() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
