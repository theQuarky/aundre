import 'package:audre/stores/locator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../env.dart';

class SocketService {
  static IO.Socket? socket;
  static void connectToServer({required String userId}) {
    if (socket != null) {
      return;
    }

    socket = IO.io(
        socketUrl, IO.OptionBuilder().setTransports(['websocket']).build());
    socket!.emit('join', {'uid': userId});

    socket!.connect();
    socket!.onConnect((_) {
      socket!.emit('join', {'uid': userId});
    });

    socket!.on('new_message', (data) {
      final Map<String, dynamic> message = {
        'message_id': data['message_id'],
        'chat_id': data['chat_id'],
        'partner_id': data['partner_id'],
        'sender_id': data['sender_id'],
        'message': data['message'],
        'sender': data['sender'],
        'created_at': data['created_at'],
      };
      locator.messageStore.addMessage(message);
    });
  }
}
