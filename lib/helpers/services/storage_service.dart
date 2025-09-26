import 'dart:convert';
import 'package:flutter_alarm_app/helpers/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _onBoardKey = 'onBoard';
  static const _locationKey = 'user_location';
  static const _alarmsKey = 'alarms';

  // onboarding
  Future<void> setOnboardingViewed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onBoardKey, true);
  }

  Future<bool?> getOnboardingViewed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onBoardKey);
  }

  // location
  Future<void> saveUserLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_locationKey, location);
  }

  Future<String?> getUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_locationKey);
  }

  // alarms
  Future<void> saveAlarms(List<Alarm> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final alarmListJson = jsonEncode(alarms.map((a) => a.toJson()).toList());
    await prefs.setString(_alarmsKey, alarmListJson);
  }

  Future<List<Alarm>> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmJson = prefs.getString(_alarmsKey);
    if (alarmJson == null) return [];

    final List<dynamic> decoded = jsonDecode(alarmJson);
    return decoded.map((item) => Alarm.fromJson(item)).toList();
  }
}
