import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

String getErrorCode(String message) {
  try {
    return message
        .split('(')[1]
        .split('/')[1]
        .replaceAll(')', '')
        .replaceAll('.', '');
  } catch (e) {
    return 'unknown';
  }
}

Future<dynamic> createUser(
    {required String email, required String password}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  } catch (e) {
    String errorMessage = 'An error occurred';
    String code = getErrorCode(e.toString());
    if (e is FirebaseAuthException) {
      code = kIsWeb ? code : e.code;
      switch (code) {
        case 'email-already-in-use':
          errorMessage = 'Email already in use';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'weak-password':
          errorMessage = 'Weak password';
          break;
        // Add more error cases as needed
        default:
          errorMessage = 'An error occurred';
      }
    }
    throw Exception(errorMessage);
  }
}

Future<dynamic> login({required String email, required String password}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  } catch (e) {
    String errorMessage = 'An error occurred';
    String code = getErrorCode(e.toString());
    if (e is FirebaseAuthException) {
      code = kIsWeb ? code : e.code;
      switch (code) {
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'user-disabled':
          errorMessage = 'Your account has been disabled';
          break;
        case 'user-not-found':
          errorMessage = 'Please register first';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password';
          break;
        // Add more error cases as needed
        default:
          errorMessage = 'An error occurred';
      }
      throw Exception(errorMessage);
    }
  }
}
