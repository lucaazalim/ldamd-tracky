class Location {
  final int orderId;
  final DateTime createdAt;
  final double latitude;
  final double longitude;

  Location({
    required this.orderId,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      orderId: json['order_id'],
      createdAt: DateTime.parse(json['created_at']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
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