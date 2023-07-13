import 'dart:convert';

import 'package:audre/models/user_model.dart';

import 'rest_api_services.dart';

class UserApiServices {
  // Method to get user profile
  // static Future<dynamic> getUserProfile() async {
  //   final response = await RestApiServices.getRequest('user/profile');

  //   return response;
  // }

  // // Method to update user profile
  // static Future<dynamic> updateUserProfile(dynamic body) async {
  //   final response = await RestApiServices.postRequest('user/profile', body);

  //   return response;
  // }

  static Future<dynamic> createUserProfile({dynamic body}) async {
    try {
      print(body);
      final response =
          await RestApiServices.postRequest('users/register', body);
      print(response);
      return response;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> checkUsernameAvailability(
      {required username, required uid}) async {
    try {
      final response = await RestApiServices.postRequest(
          'users/username-available', {'username': username, 'uid': uid});
      return response;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> searchUsers({required name}) async {
    try {
      final response =
          await RestApiServices.getRequest('users/search-users/$name');
      List<UserModal> result = response['users'].map<UserModal>((user) {
        return UserModal.fromJson(user);
      }).toList();
      return result;
    } catch (e) {
      print(e);
    }
  }
}
