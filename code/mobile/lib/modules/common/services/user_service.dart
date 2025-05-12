import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:mobile/modules/common/data/enum/order_status.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:mobile/modules/common/data/user.dart';

  class UserService {

    Future<Map<String, dynamic>> _loadMockData() async {
      final String response = await rootBundle.loadString('mock/data.json');
      return json.decode(response);
    }

    Future<User?> getUserById(int userId) async {

      final Map<String, dynamic> decodedData = await _loadMockData();
      final List<dynamic> usersData = decodedData['users'] as List<dynamic>? ?? [];

      User user;

      for (var userData in usersData) {
        if (userData['id'] == userId) {
          return user = (User.fromJson(userData));
        }
      }

      throw Exception('Usuário com ID $userId não encontrado.');

    }

  }