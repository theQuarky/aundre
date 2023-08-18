// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on UserStoreBase, Store {
  Computed<String?>? _$uidComputed;

  @override
  String? get uid => (_$uidComputed ??=
          Computed<String?>(() => super.uid, name: 'UserStoreBase.uid'))
      .value;

  late final _$userAtom = Atom(name: 'UserStoreBase.user', context: context);

  @override
  UserModal? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModal? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$UserStoreBaseActionController =
      ActionController(name: 'UserStoreBase', context: context);

  @override
  dynamic setUser(UserModal user) {
    final _$actionInfo = _$UserStoreBaseActionController.startAction(
        name: 'UserStoreBase.setUser');
    try {
      return super.setUser(user);
    } finally {
      _$UserStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
uid: ${uid}
    ''';
  }
}
