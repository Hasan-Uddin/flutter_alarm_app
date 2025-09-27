import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAlarm() async {
    await _audioPlayer.play(AssetSource('audios/alarm.mp3'));
  }

  Future<void> stopAlarm() async {
    await _audioPlayer.stop();
  }
}
