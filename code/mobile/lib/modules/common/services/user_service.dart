import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:mobile/modules/common/data/enum/order_status.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:mobile/modules/common/data/user.dart';

/// A service that provides user-related operations.
///
/// This service includes methods to fetch user data from mock data files.
class UserService {

  Future<Map<String, dynamic>> _loadMockData() async {
    final String response = await rootBundle.loadString('assets/mock/data.json');
    return json.decode(response);
  }

  Future<User?> getUserById(String userId) async {

    final Map<String, dynamic> decodedData = await _loadMockData();
    final List<dynamic> usersData = decodedData['users'] as List<dynamic>? ?? [];

    User user;

    for (var userData in usersData) {
      if (userData['id'] == userId) {
        return user = (User.fromJson(userData));
      }
    }

    throw Exception('User with ID $userId not found.');

  }

}