import 'package:audre/helpers.dart';
import 'package:audre/stores/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool hydrated = false;
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final chats = locator.messageStore.chats;
        locator.messageStore.hydrateMessages();
        if (chats.isEmpty && !hydrated) {
          locator.messageStore.hydrateChats();
          hydrated = true;
        }
        return Scaffold(
            // backgroundColor: Colors.white,
            appBar: AppBar(
                title: const Text('Chats'),
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
            body: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(chat['partner']['username']),
                    subtitle: SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                chat['last_message'] ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              format(DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(chat['last_message_time']))),
                            ),
                          ],
                        )),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(chat['partner']['profile_pic']),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/chat', arguments: {
                        'userId': chat['partner_id'] as String,
                      });
                    },
                  ),
                );
              },
            ));
      },
    );
  }
}
