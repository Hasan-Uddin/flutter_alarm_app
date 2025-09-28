import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AudioService {
  Future<void> playAlarm() async {
    FlutterRingtonePlayer().play(
      fromAsset: 'assets/audios/alarm.mp3',
      asAlarm: true,
      looping: true,
    );
  }

  Future<void> stopAlarm() async {
    FlutterRingtonePlayer().stop();
  }
}
