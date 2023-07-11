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

  static Future<dynamic> checkUsernameAvailability({required username}) async {
    try {
      final response =
          await RestApiServices.postRequest('users/username-available', {
        'username': username,
      });
      return response;
    } catch (e) {
      print(e);
    }
  }
}
