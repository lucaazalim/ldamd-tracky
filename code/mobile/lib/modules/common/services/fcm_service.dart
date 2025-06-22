import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  String? _deviceToken;
  String? get deviceToken => _deviceToken;

  Future<void> initialize() async {
    await _requestPermission();
    await _getDeviceToken();
    _listenTokenRefresh();
  }

  Future<void> _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _getDeviceToken() async {
    _deviceToken = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print('[FCM] Device Token: $_deviceToken');
    }
  }

  void _listenTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _deviceToken = newToken;
      if (kDebugMode) {
        print('[FCM] Token refreshed: $newToken');
      }
    });
  }

  Future<void> sendTokenOnRegister({
    required String name,
    required String email,
    required String password,
    required String type,
    required Dio dio,
  }) async {
    final payload = {
      'name': name,
      'email': email,
      'password': password,
      'type': type,
      'deviceToken': _deviceToken,
    };
    final response = await dio.post('/users', data: payload);
    if (kDebugMode) {
      print('[FCM] Register response: \\${response.statusCode}');
    }
  }

  Future<void> updateTokenOnLogin({
    required String userId,
    required Dio dio,
  }) async {
    final payload = {
      'deviceToken': _deviceToken,
    };
    final response = await dio.put('/users/$userId', data: payload);
    if (kDebugMode) {
      print('[FCM] Update token response: \\${response.statusCode}');
    }
  }
}
