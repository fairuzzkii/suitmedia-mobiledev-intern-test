import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://reqres.in/api';
  
  static Future<UserResponse> getUsers(int page, int perPage) async {
    print('API Call: $baseUrl/users?page=$page&per_page=$perPage');

    try {
      final uri = Uri.parse('$baseUrl/users?page=$page&per_page=$perPage');
      print('URI: $uri');

      final response = await http.get(
        uri,
        headers: {
          'x-api-key': 'reqres-free-v1',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('JSON decoded successfully');

        final userResponse = UserResponse.fromJson(jsonData);
        print('UserResponse created: ${userResponse.data.length} users');

        return userResponse;
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Error Body: ${response.body}');
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Exception in getUsers: $e');
      print('Exception type: ${e.runtimeType}');
      rethrow;
    }
  }

}