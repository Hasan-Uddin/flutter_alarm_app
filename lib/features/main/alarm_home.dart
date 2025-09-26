import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/constants/colors.dart';
import 'package:flutter_alarm_app/helpers/alarm.dart';
import 'package:flutter_alarm_app/main.dart';
import 'package:flutter_alarm_app/helpers/services/storage_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmHome extends StatefulWidget {
  const AlarmHome({super.key});
  @override
  _AlarmHomeState createState() => _AlarmHomeState();
}

class _AlarmHomeState extends State<AlarmHome> {
  String? _userLocation;
  final StorageService _storageService = StorageService();
  List<Alarm> alarms = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadLocation();
    _loadAlarms();
  }

  Future<void> _requestPermissions() async {
    await flutterLocNotifyPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> _saveAlarms() async {
    await _storageService.saveAlarms(alarms);
  }

  Future<void> _loadAlarms() async {
    final loadedAlarms = await _storageService.loadAlarms();
    setState(() => alarms = loadedAlarms);
    // Re-schedule all active alarms on app start
    for (var alarm in alarms) {
      if (alarm.isActive) {
        _scheduleAlarm(alarm);
      }
    }
  }

  Future<void> _loadLocation() async {
    final location = await _storageService.getUserLocation();
    setState(() {
      _userLocation = location ?? 'Location not set';
    });
  }

  Future<void> _scheduleAlarm(Alarm alarm) async {
    final scheduledTZDateTime = tz.TZDateTime.from(
      alarm.alarmDateTime,
      tz.local,
    );

    await flutterLocNotifyPlugin.zonedSchedule(
      alarm.id, // Use the alarm's unique id
      'Alarm',
      'It\'s time: ${alarm.time}',
      scheduledTZDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarms',
          channelDescription: 'Alarm notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          DateTimeComponents.time, // For daily repeating alarms
    );
  }

  set_alarm() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      var now = DateTime.now();
      var alarmDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      if (alarmDateTime.isBefore(now)) {
        alarmDateTime = alarmDateTime.add(const Duration(days: 1));
      }

      final newAlarm = Alarm(
        id: DateTime.now().millisecondsSinceEpoch % 10000000,
        alarmDateTime: alarmDateTime,
      );

      setState(() {
        alarms.add(newAlarm);
      });

      await _scheduleAlarm(newAlarm);
      await _saveAlarms();
    }
  }

  Future<void> _cancelAlarm(int id) async {
    await flutterLocNotifyPlugin.cancel(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: set_alarm,
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add), // Icon displayed on the button
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selected Location",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(69),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.grey[300]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _userLocation ?? 'Location not set',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 201, 201, 201),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),

            SizedBox(height: 20),
            Text(
              'Alarms',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  return Dismissible(
                    key: Key(alarm.id.toString()),
                    onDismissed: (direction) async {
                      await _cancelAlarm(alarm.id);
                      setState(() {
                        alarms.removeAt(index);
                      });
                      await _saveAlarms();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${alarm.time} alarm dismissed'),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.red[400],
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(75, 66, 66, 66),
                        borderRadius: BorderRadius.circular(69),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              child: Row(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    alarm.time,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    alarm.date,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(110, 255, 255, 255),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                            value: alarm.isActive,
                            onChanged: (val) async {
                              setState(() {
                                alarm.isActive = val;
                              });
                              if (alarm.isActive) {
                                await _scheduleAlarm(alarm);
                              } else {
                                await _cancelAlarm(alarm.id);
                              }
                              await _saveAlarms();
                            },
                            inactiveTrackColor: Colors.white,
                            activeTrackColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            inactiveThumbColor: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
