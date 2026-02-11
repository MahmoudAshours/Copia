import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class CopiaAudioHandler extends BaseAudioHandler with SeekHandler {
  CopiaAudioHandler() {
    _player.playbackEventStream.listen(_broadcastState);
  }

  final AudioPlayer _player = AudioPlayer();

  Future<void> playPath({required String path, required String title}) async {
    mediaItem.add(MediaItem(id: path, title: title, artist: 'Copia'));
    await _player.setAudioSource(AudioSource.uri(Uri.file(path)));
    await _player.play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {}

  void _broadcastState(PlaybackEvent event) {
    playbackState.add(
      PlaybackState(
        controls: const [
          MediaControl.pause,
          MediaControl.play,
          MediaControl.stop,
        ],
        androidCompactActionIndices: const [0, 1, 2],
        playing: _player.playing,
        processingState: _mapState(_player.processingState),
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ),
    );
  }

  AudioProcessingState _mapState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  @override
  Future<void> onTaskRemoved() async {
    await _player.dispose();
    await super.onTaskRemoved();
  }
}
