import 'package:audre/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserProvider {
  static User? state;

  static void setUser(user) {
    state = user;
  }

  static User? getUser() {
    return state;
  }
}

class UserProvider {
  static UserModal? state;

  static void setUser(user) {
    state = user;
  }

  static UserModal? getUser() {
    return state;
  }
}
