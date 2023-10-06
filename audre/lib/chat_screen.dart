import 'dart:io';

import 'package:audre/components/media_preview.dart';
import 'package:audre/models/user_model.dart';
import 'package:audre/services/user_graphql_services.dart';
import 'package:audre/stores/locator.dart';
import 'package:audre/providers/user_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audre/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'services/socket_services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ChatScreen extends StatefulWidget {
  final String partnerId;
  const ChatScreen({super.key, required this.partnerId});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  UserModal? user = UserProvider.getUser();
  UserModal? partner;
  String? mediaUrl;

  @override
  void initState() {
    super.initState();
    UserGraphQLService.getUser(widget.partnerId).then((value) {
      setState(() {
        partner = value;
      });
    });
  }

  void sendMessage() {
    String messageText = messageController.text.trim();
    if (messageText.isNotEmpty || mediaUrl != null) {
      final message = {
        'partner_id': widget.partnerId,
        'sender_id': user!.uid,
        'message': {
          'message': messageText,
          'media_url': mediaUrl,
        },
      };
      SocketService.socket!.emit('chat_message', message);
      messageController.clear();
      setState(() {
        mediaUrl = null;
      });
    }
  }

  Future<void> pickImageOrVideo() async {
    final picker = ImagePicker();

    if (kIsWeb) {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      final extension = pickedFile!.files.first.name.split('.').last;

      final allowExtensions = ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov'];

      if (!allowExtensions.contains(extension)) {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context, builder: (_) => const Text('Invalid file'));
        return;
      }

      String type = 'image';

      if (extension == 'mp4' || extension == 'mov') {
        type = 'video';
      }
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child("chats/$type${DateTime.now()}.$extension");

      ref.updateMetadata(SettableMetadata(
        contentType: '$type/$extension',
      ));

      UploadTask uploadTask = ref.putData(pickedFile.files.first.bytes!);

      uploadTask.then((res) async {
        final url = (await res.ref.getDownloadURL()).toString();
        setState(() {
          mediaUrl = url;
        });
      });
      return;
    }
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final extension = pickedFile!.path.split('.').last;
    final allowExtensions = ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov'];

    if (!allowExtensions.contains(extension)) {
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (_) => const Text('Invalid file'));
      return;
    }

    String type = 'image';

    if (extension == 'mp4' || extension == 'mov') {
      type = 'video';
    }

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child("chats/$type${DateTime.now()}.$extension");
    ref.updateMetadata(SettableMetadata(
      contentType: '$type/$extension',
    ));
    UploadTask uploadTask = ref.putFile(File(pickedFile.path));
    uploadTask.then((res) async {
      final url = (await res.ref.getDownloadURL()).toString();
      setState(() {
        mediaUrl = url;
      });
    });

    // Show a bottom sheet to choose between photo and video
    // await showModalBottomSheet<void>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: <Widget>[
    //         ListTile(
    //           leading: const Icon(Icons.photo),
    //           title: const Text('Pick a Photo'),
    //           onTap: () async {
    //             Navigator.pop(context);

    //             // Handle the picked image file here
    //           },
    //         ),
    //         ListTile(
    //           leading: const Icon(Icons.video_library),
    //           title: const Text('Pick a Video'),
    //           onTap: () async {
    //             Navigator.pop(context);
    //             final pickedFile =
    //                 await picker.pickVideo(source: ImageSource.gallery);

    //             final extension = pickedFile!.path.split('.').last;

    //             FirebaseStorage storage = FirebaseStorage.instance;
    //             Reference ref =
    //                 storage.ref().child("video1${DateTime.now()}.$extension");
    //             UploadTask uploadTask = ref.putFile(File(pickedFile.path));

    //             uploadTask.then((res) {
    //               setState(() async {
    //                 mediaUrl = (await res.ref.getDownloadURL()).toString();
    //               });
    //             });

    //             // Handle the picked video file here
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  void showMediaPreview() {
    showDialog(
      context: context,
      builder: (_) => MediaPreviewDialog(
        mediaUrl: mediaUrl!,
        caption: messageController.text,
      ),
    );
  }

  Widget mediaPreview() {
    if (mediaUrl!.contains('image')) {
      return GestureDetector(
        onTap: showMediaPreview,
        child: SizedBox(
          height: 150,
          width: 150,
          child: Image.network(
            mediaUrl!,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (mediaUrl!.contains('video')) {
      return GestureDetector(
        onTap: showMediaPreview,
        child: const SizedBox(
          height: 150,
          width: 150,
          child: Center(
            child: Icon(Icons.play_arrow),
          ),
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (locator.messageStore.messages.isEmpty) {
        locator.messageStore.hydrateMessages();
      }

      if (locator.messageStore.chatMessages[widget.partnerId] == null) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(partner?.username ?? 'Loading...'),
            leading: CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(partner?.profile_pic ??
                  ''), // Replace with actual avatar image
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('No messages yet'),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        pickImageOrVideo();
                      },
                      icon: const Icon(Icons.camera_alt)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.83,
                    height: messageController.text.length < 40
                        ? 50
                        : messageController.text.length * 20.0,
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: messageController,
                        maxLines: null,
                        autocorrect: true,
                        autofocus: true,
                        enableIMEPersonalizedLearning: true,
                        decoration: const InputDecoration(
                          hintText: 'Type your message here...',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ],
          ),
        );
      }

      List<dynamic> messages =
          locator.messageStore.chatMessages[widget.partnerId]!.toList();
      // remove duplicates from messages where message_id is same

      Set<String> uniqueIds = {};
      List<Map<String, dynamic>> uniqueList = [];

      for (var item in messages) {
        var itemId = item['message_id'];
        if (!uniqueIds.contains(itemId)) {
          uniqueIds.add(itemId);
          uniqueList.add(item);
        }
      }
      messages = uniqueList;

      return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            title: Text(partner?.username ?? 'Loading...'),
            leading: Container(
              margin: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(partner?.profile_pic ??
                    ''), // Replace with actual avatar image
              ),
            )),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final newIndex = messages.length - 1 - index;

                  return ChatBubble(
                    message: messages[newIndex]['message'] ?? '',
                    timestamp: messages[newIndex]['created_at'] ?? '',
                    sender: messages[newIndex]['sender'] ?? '',
                    mediaUrl: messages[newIndex]['media'],
                  );
                },
              ),
            ),
            mediaUrl != null ? mediaPreview() : Container(),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      pickImageOrVideo();
                    },
                    icon: const Icon(Icons.camera_alt, color: Colors.white)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.83,
                  height: messageController.text.length < 40
                      ? 50
                      : messageController.text.length * 20.0,
                  child: Container(
                    color: Colors.grey[300],
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: messageController,
                        maxLines: null,
                        autocorrect: true,
                        autofocus: true,
                        enableIMEPersonalizedLearning: true,
                        decoration: const InputDecoration(
                          hintText: 'Type your message here...',
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String timestamp;
  final dynamic sender;
  final String? mediaUrl;

  const ChatBubble({
    Key? key,
    required this.message,
    this.mediaUrl,
    required this.timestamp,
    required this.sender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert timestamp to DateTime
    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(
                sender['profile_pic']), // Replace with actual avatar image
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sender['username'], // Display sender's username
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                mediaUrl != null
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => MediaPreviewDialog(
                              mediaUrl: mediaUrl!,
                              caption: message,
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.network(
                            mediaUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 4.0),
                Text(
                  format(dateTime), // Display formatted timestamp
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
