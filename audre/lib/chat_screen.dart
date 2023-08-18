import 'package:audre/models/user_model.dart';
import 'package:audre/stores/locator.dart';
import 'package:audre/providers/user_provider.dart';
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

  @override
  void initState() {
    super.initState();
  }

  void sendMessage() {
    String messageText = messageController.text.trim();
    if (messageText.isNotEmpty) {
      final message = {
        'partner_id': widget.partnerId,
        'sender_id': user!.uid,
        'message': messageText,
      };
      SocketService.socket!.emit('chat_message', message);
      messageController.clear();
    }
  }

  Future<void> pickImageOrVideo() async {
    final picker = ImagePicker();

    // Show a bottom sheet to choose between photo and video
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Pick a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                // Handle the picked image file here
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Pick a Video'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile =
                    await picker.pickVideo(source: ImageSource.gallery);
                // Handle the picked video file here
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (locator.messageStore.messages.isEmpty) {
        locator.messageStore.hydrateMessages();
      }
      List<dynamic> messages =
          locator.messageStore.chatMessages[widget.partnerId].toList();

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
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Flutter Socket.IO Chat')),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final newIndex = messages.length - index - 1;
                  return ChatBubble(
                    message: messages[newIndex]['message'] ?? '',
                    timestamp: messages[newIndex]['created_at'] ?? '',
                    sender: messages[newIndex]['sender'] ?? '',
                  );
                },
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      pickImageOrVideo();
                    },
                    icon: const Icon(Icons.camera_alt)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
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
    });
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String timestamp;
  final dynamic sender;

  const ChatBubble({
    Key? key,
    required this.message,
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
