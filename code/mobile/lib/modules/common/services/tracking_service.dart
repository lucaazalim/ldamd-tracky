import 'package:dio/dio.dart';
import 'package:mobile/modules/common/data/tracking.dart';
import 'package:mobile/modules/common/dio.dart';


class TrackingService {
  final Dio _dio = DioClient().dio;

  Future<Tracking?> getLatestLocationForOrder(String orderId) async {
    try {
      final response = await _dio.get('/tracking/$orderId/latest');
      if (response.data == null) return null;
      return Tracking.fromJson(response.data);
    } catch (e) {
      print('Error fetching order location from API: $e');
      return null;
    }
  }
}