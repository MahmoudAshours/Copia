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

class _BottomAudioPlayerState extends State<BottomAudioPlayer> {
  FlutterSoundPlayer flutterSoundPlayer;
  @override
  void initState() {
    _initializeSoundPlayer();
    super.initState();
  }

  @override
  void dispose() {
    flutterSoundPlayer.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Hive.box('name').getAt(widget.index).soundPath != null)
      return AnimatedOpacity(
        opacity: widget.hideFab ? 0.0 : 1.0,
        duration: Duration(milliseconds: 400),
        child: Container(
          color: Colors.red,
          height: 50,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  var audio = Hive.box('name').getAt(widget.index).soundPath;
                  print(audio);
                  flutterSoundPlayer.startPlayer(audio);
                },
              ),
              IconButton(
                icon: Icon(Icons.pause),
                onPressed: () {
                  flutterSoundPlayer.pausePlayer();
                },
              )
            ],
          ),
        ),
      );
    return SizedBox();
  }

  Future _initializeSoundPlayer() async {
    flutterSoundPlayer = await FlutterSoundPlayer().initialize();
  }
}
