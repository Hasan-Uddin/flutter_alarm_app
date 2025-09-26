import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/features/location/location_screen.dart';
import 'package:flutter_alarm_app/features/onboarding/onboarding_screen.dart';
import 'package:flutter_alarm_app/helpers/dark_theme.dart';
import 'package:flutter_alarm_app/helpers/services/storage_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocNotifyPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

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

  const AndroidInitializationSettings androidInitSets =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initSets = InitializationSettings(
    android: androidInitSets,
  );
  await flutterLocNotifyPlugin.initialize(initSets);

  // first time app opened already?
  final storageService = StorageService();
  final isViewed = await storageService.getOnboardingViewed();

  runApp(MyApp(isViewed: isViewed));
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
