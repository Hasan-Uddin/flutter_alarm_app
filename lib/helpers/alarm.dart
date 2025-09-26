import 'package:intl/intl.dart';

class Alarm {
  final int id;
  DateTime alarmDateTime;
  bool isActive;

  Alarm({required this.id, required this.alarmDateTime, this.isActive = true});

  String get time => DateFormat('h:mm a').format(alarmDateTime);
  String get date => DateFormat('E, d MMM yyyy').format(alarmDateTime);

  Map<String, dynamic> toJson() => {
    'id': id,
    'alarmDateTime': alarmDateTime.toIso8601String(),
    'isActive': isActive,
  };

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
    id: json['id'],
    alarmDateTime: DateTime.parse(json['alarmDateTime']),
    isActive: json['isActive'],
  );
}
