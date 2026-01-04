import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer player = AudioPlayer();

  Stream<double> get positionStream =>
      player.positionStream.map((d) => d.inSeconds.toDouble());

  double get durationSeconds =>
      player.duration?.inSeconds.toDouble() ?? 0;

  
  // 🔹 Playback completion stream (IMPORTANT)
  Stream<void> get onComplete =>
      player.playerStateStream
          .where((state) =>
              state.processingState == ProcessingState.completed)
          .map((_) => null);

  Future<void> play(String filePath) async {
    await player.setFilePath(filePath);
    await player.play();
  }

  Future<void> pause() async => player.pause();

  Future<void> resume() async => player.play();

  Future<void> stop() async => player.stop();

  Future<void> seek(double seconds) async {
    await player.seek(Duration(seconds: seconds.toInt()));
  }

  Future<void> dispose() async => player.dispose();
}
