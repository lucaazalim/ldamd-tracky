import 'package:intl/intl.dart';

class Tracking {
  final String orderId;
  final DateTime createdAt;
  final double latitude;
  final double longitude;

  Tracking({
    required this.orderId,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      orderId: json['order_id'] ?? json['orderId'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? json['createdAt']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return 'LocationPoint(orderId: $orderId, createdAt: \\${formatter.format(createdAt)}, latitude: $latitude, longitude: $longitude)';
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'created_at': createdAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}