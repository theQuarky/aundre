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
      final response =
          await RestApiServices.postRequest('users/register', body);
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

  static Future<dynamic> searchUsers({required name, required uid}) async {
    try {
      final response = await RestApiServices.postRequest(
          'users/search-users/$name', {'uid': uid});
      List<UserModal> result = response['users'].map<UserModal>((user) {
        return UserModal.fromJson(user);
      }).toList();
      return result;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> followUser({required uid, required followId}) async {
    try {
      final response = await RestApiServices.postRequest(
          'users/follow-user', {'uid': uid, 'follow_uid': followId});
      return response;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> unfollowUser(
      {required uid, required unfollowId}) async {
    try {
      final response = await RestApiServices.postRequest(
          'users/unfollow-user', {'uid': uid, 'follow_uid': unfollowId});
      return response;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> cancelFollowRequest(
      {required uid, required cancelId}) async {
    try {
      final response = await RestApiServices.postRequest(
          'users/cancel-follow-request', {'uid': uid, 'follow_uid': cancelId});
      return response;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> acceptFollowRequest(
      {required uid, required acceptId}) async {
    try {
      final response = await RestApiServices.postRequest(
          'users/accept-follow-request', {'uid': uid, 'follow_uid': acceptId});
      return response;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> rejectFollowRequest(
      {required uid, required rejectId}) async {
    try {
      final response = await RestApiServices.postRequest(
          'users/reject-follow-request', {'uid': uid, 'follow_uid': rejectId});
      return response;
    } catch (e) {
      print(e);
    }
  }
}
