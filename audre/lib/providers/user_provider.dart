import 'package:audre/models/user_model.dart';
import 'package:audre/services/user_graphql_services.dart';
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

  static Future<UserModal?> getUser() async {
    if (state == null) {
      String uid = FirebaseUserProvider.getUser()!.uid;
      final user = await UserGraphQLService.getUser(uid);
      print(user);
      // state = user;
    }
    return state;
  }
}
