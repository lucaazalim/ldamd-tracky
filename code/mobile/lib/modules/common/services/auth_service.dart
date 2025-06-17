import 'dart:convert';
import 'package:flutter/services.dart';

/// A service that handles authentication operations.
///
/// This service includes methods to log in users using mock data.
class AuthService {
  Future<Map<String, dynamic>> _loadMockData() async {
    final String response = await rootBundle.loadString('assets/mock/data.json');
    return json.decode(response);
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final mockData = await _loadMockData();
    final users = mockData['users'] as List<dynamic>;

    for (final user in users) {
      if (user['email'] == email && user['password'] == password) {
        return user as Map<String, dynamic>;
      }
    }
    return null;
  }
}