import 'package:mobile/modules/common/data/user.dart';
import 'package:mobile/modules/common/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final dioClient = DioClient().dio;

  Future<User?> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        '/users/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        final token = response.data['token'];
        DioClient().setAuthToken(token);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return User.fromJson(response.data['user']);
      }
      return null;
    } catch (e) {
      print('Error doing login: $e');
      return null;
    }
  }

  static Future<void> setAuthTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      DioClient().setAuthToken(token);
    }
  }
  
  Future<User?> registerUser(User user) async {
    try {
      final response = await dioClient.post(
        '/users',
        data: {
          'name': user.name,
          'email': user.email,
          'password': user.password,
          'type': user.type
        },
      );
      if (response.statusCode == 201 && response.data != null) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error doing register: $e');
      return null;
    }
  }

}