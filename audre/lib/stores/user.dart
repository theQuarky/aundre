import 'package:audre/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'user.g.dart';

class UserStore = UserStoreBase with _$UserStore;

abstract class UserStoreBase with Store {
  @observable
  UserModal? user = UserModal();

  @action
  setUser(UserModal user) => this.user = user;

  @computed
  String? get uid => FirebaseAuth.instance.currentUser!.uid;
}
