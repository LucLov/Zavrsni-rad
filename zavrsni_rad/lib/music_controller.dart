import 'package:audioplayers/audioplayers.dart';

class MusicController {
  static final MusicController _instance = MusicController._internal();
  factory MusicController() => _instance;

  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _feedbackPlayer = AudioPlayer();
  bool _isPlaying = false;

  MusicController._internal();

  Future<void> startMusic() async {
    if (!_isPlaying) {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('audio/background_music_final.mp3'));
      await _player.setVolume(0.3);
      _isPlaying = true;
    }
  }

  Future<void> stopMusic() async {
    await _player.stop();
    _isPlaying = false;
  }

  Future<void> updateMusic(bool shouldPlay) async {
    if (shouldPlay) {
      await startMusic();
    } else {
      await stopMusic();
    }
  }

  Future<void> playFeedbackSound(String assetPath) async {
    if (assetPath == "audio/right_feedback.mp3") {
      await _feedbackPlayer.setVolume(0.7);
    }
    await _feedbackPlayer.play(AssetSource(assetPath));
  }

  Future<void> dispose() async {
    await _player.stop();
    await _player.dispose();
    await _feedbackPlayer.dispose();
    _isPlaying = false;
  }
}
