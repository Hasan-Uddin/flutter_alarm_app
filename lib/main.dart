import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/features/location/location_screen.dart';
import 'package:flutter_alarm_app/features/onboarding/onboarding_screen.dart';
import 'package:flutter_alarm_app/helpers/dark_theme.dart';
import 'package:flutter_alarm_app/helpers/services/audio_service.dart';
import 'package:flutter_alarm_app/helpers/services/notification_service.dart';
import 'package:flutter_alarm_app/helpers/services/storage_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

final NotificationService notificationService = NotificationService();
final AudioService audioService = AudioService();

void onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) async {
  if (notificationResponse.payload == 'stop_alarm' ||
      notificationResponse.actionId == 'stop_alarm') {
    if (!kIsWeb) {
      final service = FlutterBackgroundService();
      service.invoke('stopAlarm');
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await initNotifications();

  // only portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // statusbar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light, // light icons
      statusBarColor: Colors.transparent, // Set status bar color
    ),
  );

  // first time app opened already?
  final storageService = StorageService();
  final isViewed = await storageService.getOnboardingViewed();

  runApp(MyApp(isViewed: isViewed));
}

Future<void> initNotifications() async {
  await notificationService.init(onDidReceiveNotificationResponse);
}

class MyApp extends StatelessWidget {
  final bool? isViewed;
  const MyApp({super.key, this.isViewed});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Alarm App',
      theme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: isViewed == true
          ? const LocationScreen()
          : const OnboardingScreen(),
    );
  }
}
