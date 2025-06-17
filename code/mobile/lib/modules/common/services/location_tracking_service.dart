import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mobile/modules/common/data/location.dart'; // Import the new model

/// A service that provides location tracking for orders.
///
/// This service fetches the latest location data for a specific order from mock data files.
class LocationTrackingService {
  Future<Map<String, dynamic>> _loadMockData() async {
    final String response = await rootBundle.loadString('assets/mock/data.json');
    return json.decode(response);
  }


  Future<Location?> getLatestLocationForOrder(String orderId) async {
    try {
      final mockData = await _loadMockData();
      final locations = (mockData['locations'] as List<dynamic>?) ?? [];

      final orderLocations = locations
          .map((json) => Location.fromJson(json))
          .where((location) => location.orderId == orderId)
          .toList();

      if (orderLocations.isEmpty) {
        return null;
      }

      orderLocations.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orderLocations.first;

    } catch (e) {
      print('Error fetching order location: $e');

      return null;
    }
  }
}