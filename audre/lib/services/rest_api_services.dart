import 'dart:convert';
import 'package:audre/env.dart';
import 'package:http/http.dart' as http;

class RestApiServices {
  // Base URL of your API

  // Method to make a GET request
  static Future<dynamic> getRequest(String path) async {
    final response = await http.get(Uri.parse('$baseUrl/$path'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to make GET request: ${response.statusCode}');
    }
  }

  // Method to make a POST request
  static Future<dynamic> postRequest(String path, dynamic body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$path'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to make POST request: ${response.statusCode}');
    }
  }
}
