import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';
import 'package:audio_session/audio_session.dart';

class Player extends StatefulWidget {
  final String audioUrl;
  const Player({super.key, required this.audioUrl});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  double containerHeight = 100.0;
  final _player = AudioPlayer(
    // Handle audio_session events ourselves for the purpose of this demo.
    handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );
  void _handleInterruptions(AudioSession audioSession) {
    // just_audio can handle interruptions for us, but we have disabled that in
    // order to demonstrate manual configuration.
    bool playInterrupted = false;
    audioSession.becomingNoisyEventStream.listen((_) {
      _player.pause();
    });
    _player.playingStream.listen((playing) {
      playInterrupted = false;
      if (playing) {
        audioSession.setActive(true);
      }
    });
    audioSession.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes!.usage ==
                AndroidAudioUsage.game) {
              _player.setVolume(_player.volume / 2);
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (_player.playing) {
              _player.pause();
              playInterrupted = true;
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _player.setVolume(min(1.0, _player.volume * 2));
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (playInterrupted) _player.play();
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            playInterrupted = false;
            break;
        }
      }
    });
  }

  // Function to start the animation loop

  // Function to animate the container height and loop
  void animateContainerLoop() {
    setState(() {
      containerHeight = Random().nextInt(100).toDouble();
    });
    startAnimationLoop();
  }

  void startAnimationLoop() {
    // Delay before starting the loop (optional)
    Future.delayed(const Duration(milliseconds: 500), () {
      animateContainerLoop();
    });
  }

  @override
  void initState() {
    super.initState();
    AudioSession.instance.then((audioSession) async {
      // This line configures the app's audio session, indicating to the OS the
      // type of audio we intend to play. Using the "speech" recipe rather than
      // "music" since we are playing a podcast.
      await audioSession.configure(const AudioSessionConfiguration.speech());
      // Listen to audio interruptions and pause or duck as appropriate.
      _handleInterruptions(audioSession);
      // Use another plugin to load audio to play.
      await _player.setUrl(widget.audioUrl);
    });
    startAnimationLoop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(100)),
      child: StreamBuilder<PlayerState>(
        stream: _player.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          if (playerState?.processingState != ProcessingState.ready) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 75.0,
              height: 75.0,
              child: const CircularProgressIndicator(),
            );
          } else {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: playerState?.playing == true
                  ? animation()
                  : IconButton(
                      key:
                          UniqueKey(), // Use UniqueKey for AnimatedSwitcher to recognize different children
                      onPressed: () {
                        _player.play();
                      },
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      iconSize: 70,
                    ),
            );
          }
        },
      ),
    );
  }

  Widget animation() {
    return GestureDetector(
      onTap: () {
        _player.pause();
      },
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
              6,
              (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 10,
                  curve: Curves.easeInOut,
                  height: 10 + (Random().nextInt(10) * 10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      // color: Colors.black,
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.purple, Colors.blue]),
                      borderRadius: BorderRadius.circular(100))))),
    );
  }
}
