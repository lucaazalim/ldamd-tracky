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

  Future<Tracking?> createTracking(Tracking newTracking) async {
    try {
      final response = await _dio.post(
        '/tracking',
        data: {
          'orderId': newTracking.orderId,
          'latitude': newTracking.latitude,
          'longitude': newTracking.longitude
        }
      );

      if (response.statusCode == 201 && response.data != null) {
        return Tracking.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error creating tracking from API: $e');
      return null;
    }

  }
  Future<void> sendTracking({required String orderId, required double latitude, required double longitude}) async {
    try {
      await _dio.post('/tracking', data: {
        'order_id': orderId,
        'latitude': latitude,
        'longitude': longitude,
      });
    } catch (e) {
      print('Error sending tracking: $e');
    }
  }
}
