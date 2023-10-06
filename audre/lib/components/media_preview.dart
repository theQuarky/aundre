import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaPreviewDialog extends StatefulWidget {
  final String mediaUrl;
  final String caption;

  const MediaPreviewDialog(
      {super.key, required this.mediaUrl, required this.caption});

  @override
  _MediaPreviewDialogState createState() => _MediaPreviewDialogState();
}

class _MediaPreviewDialogState extends State<MediaPreviewDialog> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    if (widget.mediaUrl.contains('video')) {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl))
            ..initialize().then((_) {
              setState(() {});
            });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.mediaUrl.contains('image')
              ? Image.network(widget.mediaUrl, fit: BoxFit.fitWidth)
              : _videoPlayerController.value.isInitialized
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_videoPlayerController.value.isPlaying) {
                            _videoPlayerController.pause();
                          } else {
                            _videoPlayerController.play();
                          }
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController),
                          ),
                          if (!_videoPlayerController.value.isPlaying)
                            const Icon(Icons.play_arrow, size: 64),
                        ],
                      ),
                    )
                  : const CircularProgressIndicator(),
          widget.caption != ''
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.caption,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
