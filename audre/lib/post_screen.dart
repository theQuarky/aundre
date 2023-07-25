import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audre/models/user_model.dart';
import 'package:audre/providers/user_provider.dart';
import 'package:audre/services/note_api_services.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  final String audioUrl;
  final String audioPath;
  const PostScreen(
      {super.key, required this.audioUrl, required this.audioPath});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late PlayerController playerController;
  final TextEditingController captionController = TextEditingController();
  UserModal? user;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      user = UserProvider.getUser();
    });
    _initialiseControllers();
  }

  void _initialiseControllers() {
    playerController = PlayerController();

    playerController.preparePlayer(
      path: widget.audioPath,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1.0,
    );
    playerController.updateFrequency = UpdateFrequency.low;
    playerController.startPlayer();
    playerController.addListener(() {
      final state = playerController.playerState;

      switch (state) {
        case PlayerState.stopped:
          setState(() {
            isPlaying = false;
          });
          break;
        case PlayerState.playing:
          setState(() {
            isPlaying = true;
          });
          break;
        case PlayerState.paused:
          setState(() {
            isPlaying = false;
          });
          break;
        default:
          setState(() {
            isPlaying = false;
          });
          break;
      }

      playerController.onCompletion.listen((_) async {
        setState(() {
          isPlaying = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple,
            Colors.deepPurple,
            Colors.blue,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    )),
                const Text('New Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AudioFileWaveforms(
                        size: Size(
                            MediaQuery.of(context).size.width / 1.5, 100.0),
                        playerController: playerController,
                        enableSeekGesture: true,
                        waveformType: WaveformType.long,
                        continuousWaveform: true,
                        playerWaveStyle: const PlayerWaveStyle(
                          fixedWaveColor: Colors.white,
                          liveWaveColor: Colors.blueAccent,
                          spacing: 6,
                        ),
                        // progressWaveStyle: const ProgressWaveStyle(
                        //   progressColor: Colors.white.withOpacity(0.8),
                        //   progressWidth: 2.0,
                        // ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (isPlaying) {
                            await playerController.pausePlayer();
                          } else {
                            await playerController.startPlayer();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          elevation: 5,
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: captionController,
                    decoration: InputDecoration(
                      hintText: 'Caption...',
                      hintStyle:
                          const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 31, 31, 31), fontSize: 18),
                    cursorColor: const Color.fromARGB(255, 0, 0, 0),
                    textAlign: TextAlign.start,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          NoteApiServices.createNote(
                                  mediaUrl: widget.audioUrl,
                                  createdBy: user!.uid,
                                  caption: captionController.text)
                              .then((value) {
                            print(value);
                            Navigator.of(context).popAndPushNamed('/home');
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                          elevation: 5,
                        ),
                        child: const Text('Post'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
