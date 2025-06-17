import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:  'http://locahost:8080/api',
      connectTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Dio get dio => _dio;


// DIO de User Service que funciona enquanto ainda houver erro de cors do api gateway.
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  final Dio _dioUserService = Dio(
    BaseOptions(
      baseUrl:  'http://localhost:8081/',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Dio get dioUserService => _dioUserService;

  void setAuthTokenUserService(String token) {
    _dioUserService.options.headers['Authorization'] = 'Bearer $token';
  }
}

