// import 'dart:async';
// import 'dart:ui';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter_alarm_app/helpers/services/notification_service.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true,
//       autoStart: true,
//     ),
//     iosConfiguration: IosConfiguration(onForeground: onStart, autoStart: true),
//   );
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();

//   final audioPlayer = AudioPlayer();
//   final notificationService = NotificationService();
//   await notificationService.init((p0) => null);

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   service.on('stopAlarm').listen((event) async {
//     await audioPlayer.stop();
//     await notificationService.cancelAllAlarms();
//   });
// }
