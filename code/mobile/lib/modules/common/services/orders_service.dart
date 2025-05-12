import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:mobile/modules/common/data/enum/order_status.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:mobile/modules/common/services/user_service.dart';

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


  Future<List<Order>> getCurrentOrdersByDriverId(int driverId) async {

    final Map<String, dynamic> decodedData = await _loadMockData();
    final List<dynamic> ordersData = decodedData['orders'] as List<dynamic>? ?? [];
    List<Order> driverOrders = [];

    for (var orderData in ordersData) {
      if (orderData['driver_id'] == driverId && orderData['status'] != 'DELIVERED' && orderData['status'] != 'PENDING') {
        driverOrders.add(Order.fromJson(orderData));
      }
    }

    try {
      for (var order in driverOrders) {
        order.driver = await UserService().getUserById(order.driverId);
        print("driver: ${order.driver?.username}");

        order.costumer = await UserService().getUserById(order.customerId);
        print("costumer: ${order.costumer?.username}");
      }
    } catch (e, stacktrace) {
      print("Erro ao buscar usuários: $e");
      print(stacktrace);
    }


    return driverOrders;

  }

  Future<List<Order>> getAvailableOrdersByDriverId(int driverId) async {

    final Map<String, dynamic> decodedData = await _loadMockData();
    final List<dynamic> ordersData = decodedData['orders'] as List<dynamic>? ?? [];
    List<Order> driverOrders = [];

    for (var orderData in ordersData) {

      if (orderData['driver_id'] == driverId && orderData['status'] == 'PENDING') {
        driverOrders.add(Order.fromJson(orderData));
      }

    }

    for (var order in driverOrders) {
      order.driver = await UserService().getUserById(order.driverId);
      order.costumer = await UserService().getUserById(order.customerId);
    }

    return driverOrders;

  }


  Future<Order>? updateOrderStatus( int orderId, XFile image, OrderStatus? orderStatus){

    if(orderStatus != null){
      print("atualizando status!");
    }

    if(orderStatus != null){
      print("imagem atualizada!");
    }

    return null;

  }


}