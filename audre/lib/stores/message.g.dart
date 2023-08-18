// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MessageStore on MessageStoreBase, Store {
  late final _$messagesAtom =
      Atom(name: 'MessageStoreBase.messages', context: context);

  @override
  List<Map<String, dynamic>> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(List<Map<String, dynamic>> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  late final _$chatsAtom =
      Atom(name: 'MessageStoreBase.chats', context: context);

  @override
  List<Map<String, dynamic>> get chats {
    _$chatsAtom.reportRead();
    return super.chats;
  }

  @override
  set chats(List<Map<String, dynamic>> value) {
    _$chatsAtom.reportWrite(value, super.chats, () {
      super.chats = value;
    });
  }

  late final _$chatPageAtom =
      Atom(name: 'MessageStoreBase.chatPage', context: context);

  @override
  int get chatPage {
    _$chatPageAtom.reportRead();
    return super.chatPage;
  }

  @override
  set chatPage(int value) {
    _$chatPageAtom.reportWrite(value, super.chatPage, () {
      super.chatPage = value;
    });
  }

  late final _$messagePageAtom =
      Atom(name: 'MessageStoreBase.messagePage', context: context);

  @override
  int get messagePage {
    _$messagePageAtom.reportRead();
    return super.messagePage;
  }

  @override
  set messagePage(int value) {
    _$messagePageAtom.reportWrite(value, super.messagePage, () {
      super.messagePage = value;
    });
  }

  late final _$MessageStoreBaseActionController =
      ActionController(name: 'MessageStoreBase', context: context);

  @override
  dynamic addMessage(Map<String, dynamic> message) {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.addMessage');
    try {
      return super.addMessage(message);
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void hydrateMessages() {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.hydrateMessages');
    try {
      return super.hydrateMessages();
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void hydrateChats() {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.hydrateChats');
    try {
      return super.hydrateChats();
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextPage() {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.nextPage');
    try {
      return super.nextPage();
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
messages: ${messages},
chats: ${chats},
chatPage: ${chatPage},
messagePage: ${messagePage}
    ''';
  }
}
