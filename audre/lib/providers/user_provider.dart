import 'package:audre/models/user_model.dart';
import 'package:audre/services/user_graphql_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserProvider {
  static User? state;

  static void setUser(user) {
    state = user;
  }

  static User? getUser() {
    return FirebaseAuth.instance.currentUser;
  }
}

class UserProvider {
  static UserModal? state;

  static void setUser(user) {
    state = user;
  }

  static UserModal? getUser() {
    String uid = FirebaseUserProvider.getUser()!.uid;
    UserGraphQLService.getUser(uid).then((value) {
      state = value;
    });
    return state;
  }
}
