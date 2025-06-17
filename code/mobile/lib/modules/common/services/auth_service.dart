import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:mobile/modules/common/dio.dart';

/// A service that handles authentication operations.
///
/// This service includes methods to log in users using mock data.
class AuthService {

  final dioClient = DioClient().dio;

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

  Future<String?> login2(String email, String password) async {
    try {
      final response = await dioClient.post(
        "/user/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.data != null && response.data['token'] != null) {
        return response.data['token']; // pega o token da resposta
      }

      return null;

    } catch (e) {
      print('Erro ao fazer login: $e');
      return null;
    }

  }

}