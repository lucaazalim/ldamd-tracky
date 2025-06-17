import 'package:mobile/modules/common/data/user.dart';
import 'package:mobile/modules/common/dio.dart';

class UserService {
  final dioClient = DioClient().dioUserService;

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
        //DioClient().setAuthToken(response.data['token']);
        DioClient().setAuthTokenUserService(response.data['token']); // Remover quando nao tiver erro de cors no api gateway
        DioClient().setOrderServiceAuthToken(response.data['token']); // Remover quando nao tiver erro de cors no api gateway
        return User.fromJson(response.data['user']);
      }
      return null;
    } catch (e) {
      print('Error doing login: $e');
      return null;
    }
  }
}