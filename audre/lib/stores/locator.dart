import 'package:audre/stores/message.dart';

class _Locator {
  final messageStore = MessageStore();

  void setup() {
    // setup dependencies
    messageStore.hydrateMessages();
  }
}

final locator = _Locator();
