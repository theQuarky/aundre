import 'package:audre/providers/user_provider.dart';
import 'package:audre/services/message_graphql_services.dart';
import 'package:mobx/mobx.dart';

part 'message.g.dart';

class MessageStore = MessageStoreBase with _$MessageStore;

abstract class MessageStoreBase with Store {
  @observable
  List<Map<String, dynamic>> messages = [];

  @observable
  Map<String, dynamic> chatMessages = {};

  @observable
  List<Map<String, dynamic>> chats = [];

  @observable
  int chatPage = 0;

  @observable
  int messagePage = 0;

  @action
  addMessage(Map<String, dynamic> message) {
    messages = [...messages, message];

    //remove duplicates from messages where message_id is same

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

    messages.sort((a, b) => a['created_at'].compareTo(b['created_at']));
    hydrateChats();
  }

  @action
  updateMessage(Map<String, dynamic> message) {
    final temp = messages;
    messages = [];
    messages = temp
        .map((e) => e['message_id'] == message['message_id'] ? message : e)
        .toList();
    final index = messages.indexWhere(
        (element) => element['message_id'] == message['message_id']);
    print('new message ${messages[index]}');
    // hydrateMessages();
  }

  @action
  void hydrateMessages() {
    String uid = FirebaseUserProvider.getUser()!.uid;
    MessagesGraphQLService.getMessages(uid: uid, page: messagePage)
        .then((value) {
      if (value != null) {
        messages = [...messages, ...value];
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

        for (var element in messages) {
          String partnerId = element['sender_id'] == uid
              ? element['partner_id']
              : element['sender_id'];
          if (chatMessages[partnerId] == null) {
            chatMessages[partnerId] = [];
          }
          chatMessages[partnerId].add(element);
        }
      }
    });
  }

  @action
  void hydrateChats() {
    String uid = FirebaseUserProvider.getUser()!.uid;
    MessagesGraphQLService.getChats(uid: uid).then((value) {
      if (value != null) {
        chats = [...chats, ...value];
        // remove duplicates from chats where chat_id is same
        chats.sort(
            (a, b) => b['last_message_time'].compareTo(a['last_message_time']));
        Set<String> uniqueIds = {};
        List<Map<String, dynamic>> uniqueList = [];

        for (var item in chats) {
          var itemId = item['chat_id'];
          if (!uniqueIds.contains(itemId)) {
            uniqueIds.add(itemId);
            uniqueList.add(item);
          }
        }

        chats = uniqueList;
      }
    });
  }

  @action
  void nextPage() {
    messagePage++;
    hydrateMessages();
  }

  @action
  void reset() {
    messages = [];
    messagePage = 0;
  }
}
