import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound_player.dart';
import 'package:hive/hive.dart';

class BottomAudioPlayer extends StatefulWidget {
  final int index;
  final bool hideFab;

  const BottomAudioPlayer({Key key, this.index, this.hideFab})
      : super(key: key);
  @override
  _BottomAudioPlayerState createState() => _BottomAudioPlayerState();
}

class _BottomAudioPlayerState extends State<BottomAudioPlayer>
    with SingleTickerProviderStateMixin {
  FlutterSoundPlayer flutterSoundPlayer;
  AnimationController _controller;
  bool _isPlaying = false;
  Stream<PlayStatus> _playerSubscription;
  double _currentPosition;
  @override
  void initState() {
    _initializeSoundPlayer();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _currentPosition = 0.0;
    super.initState();
  }

  @override
  void dispose() {
    flutterSoundPlayer.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Hive.box('name').getAt(widget.index).soundPath != null) {
      final _soundPath = Hive.box('name').getAt(widget.index).soundPath;
      return AnimatedOpacity(
        opacity: widget.hideFab ? 0.0 : 1.0,
        duration: Duration(milliseconds: 400),
        child: Container(
          color: Colors.black,
          height: 50,
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(
                    () {
                      if (_isPlaying) {
                        _pauseAudio();
                      } else {
                        _playAudio(_soundPath);
                      }
                    },
                  );
                },
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _controller,
                  color: Colors.red,
                ),
              ),
              Container(
                width: 200,
                child: Slider(
                  value: _currentPosition,
                  inactiveColor: Colors.green,
                  activeColor: Colors.green,
                  onChanged: (double time) {
                    setState(() => _currentPosition = time);
                    seekToPlayer((time * 100).round());
                  },
                  max: 1,
                  min: 0,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  Future<void> _initializeSoundPlayer() async =>
      flutterSoundPlayer = await FlutterSoundPlayer().initialize();

  void seekToPlayer(int milliSecs) async {
    String result = await flutterSoundPlayer.seekToPlayer(milliSecs);
    print('seekToPlayer: $result');
  }

  Future<void> _pauseAudio() async {
    _isPlaying = false;
    _controller.reverse();
    await flutterSoundPlayer.pausePlayer();
  }

  Future<void> _playAudio(String _soundPath) async {
    _isPlaying = true;
    _controller.forward();
    await flutterSoundPlayer.startPlayer(_soundPath);
    // _playerSubscription = flutterSoundPlayer.onPlayerStateChanged
    //   ..listen(
    //     (PlayStatus e) {
    //       if (e != null)
    //         setState(() => _currentPosition = e.currentPosition / e.duration);
    //     },
    //   );
  }
}
