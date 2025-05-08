import 'dart:convert';
import 'package:flutter/services.dart';

class OrdersService {
  Future<Map<String, dynamic>> _loadMockData() async {
    final String response = await rootBundle.loadString('mock/data.json');
    return json.decode(response);
  }

  Future<List<Map<String, dynamic>>> getOrdersForCustomer(int customerId) async {
    final mockData = await _loadMockData();
    final orders = (mockData['orders'] as List<dynamic>?) ?? [];
    return orders.where((order) => order['customer_id'] == customerId).cast<Map<String, dynamic>>().toList();
  }
}