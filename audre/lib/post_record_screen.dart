import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './services/firebase_services.dart';

class PostRecordScreen extends StatefulWidget {
  const PostRecordScreen({super.key});

  @override
  State<PostRecordScreen> createState() => _PostRecordScreenState();
}

class _PostRecordScreenState extends State<PostRecordScreen> {
  late final RecorderController recorderController;
  String? path;
  String? musicFile;
  bool isPlaying = false;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;
  bool showRecordedWave = false;
  late PlayerController playerController;

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.wav";
    isLoading = false;
    setState(() {});
  }

  void _initialiseControllers() {
    playerController = PlayerController();
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100
      ..bitRate = 128000
      ..updateFrequency = const Duration(milliseconds: 50);

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

  void showPlayer() async {
    isRecordingCompleted = true;
    debugPrint(path);
    debugPrint("Recorded file size: ${File(musicFile!).lengthSync()}");
    await playerController.preparePlayer(
      path: musicFile!,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1.0,
    );
    playerController.updateFrequency = UpdateFrequency.low;
    playerController.addListener(_refreshWave);
    setState(() {
      showRecordedWave = true;
    });
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav'],
    );
    if (result != null) {
      musicFile = result.files.single.path;
      setState(() {
        path = musicFile;
      });
    } else {
      debugPrint("File not picked");
    }
  }

  void _startOrStopRecording() async {
    try {
      if (isRecording) {
        recorderController.reset();
        final path = await recorderController.stop(false);

        if (path != null) {
          isRecordingCompleted = true;
          debugPrint(path);
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
          await playerController.preparePlayer(
            path: path,
            shouldExtractWaveform: true,
            noOfSamples: 100,
            volume: 1.0,
          );
          playerController.updateFrequency = UpdateFrequency.low;
          playerController.addListener(_refreshWave);
          setState(() {
            showRecordedWave = true;
          });
        }
      } else {
        await recorderController.record(path: path!);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void _refreshWave() {
    if (isRecording) recorderController.refresh();
  }

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple, Colors.blue])),
        child: Scaffold(
          floatingActionButton: IconButton(
            onPressed: () {
              if (isRecordingCompleted && path != null) {
                uploadAudioFileToFirebaseStorage(filePath: path!).then((value) {
                  if (value.isNotEmpty && path != null) {
                    Map<String, String> args = {
                      'audioUrl': value,
                      'audioPath': path!,
                    };

                    print(args.runtimeType);

                    Navigator.of(context)
                        .pushNamed('/create-post', arguments: args);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please record audio first'),
                      ),
                    );
                  }
                });
              }
            },
            icon: const Icon(Icons.chevron_right_sharp,
                color: Colors.white, size: 45),
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      _startOrStopRecording();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Icon(isRecording ? Icons.stop : Icons.play_arrow,
                        size: 50),
                  ),
                ],
              )),
              const SizedBox(height: 20),
              isRecording
                  ? AudioWaveforms(
                      enableGesture: true,
                      size: Size(MediaQuery.of(context).size.width / 2, 50),
                      recorderController: recorderController,
                      waveStyle: const WaveStyle(
                        waveColor: Colors.white,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: const Color(0xFF1E1B26),
                      ),
                      padding: const EdgeInsets.only(left: 18),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              showRecordedWave
                  ? Column(
                      children: [
                        AudioFileWaveforms(
                          size: Size(MediaQuery.of(context).size.width, 100.0),
                          playerController: playerController,
                          enableSeekGesture: true,
                          waveformType: WaveformType.long,
                          continuousWaveform: true,
                          playerWaveStyle: const PlayerWaveStyle(
                            fixedWaveColor: Colors.white54,
                            liveWaveColor: Colors.blueAccent,
                            spacing: 6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (isPlaying) {
                                  await playerController.pausePlayer();
                                } else {
                                  await playerController.startPlayer();
                                }
                              },
                              child: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showRecordedWave = false;
                              });
                              _initialiseControllers();
                            },
                            child: const Text("Discard"))
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
