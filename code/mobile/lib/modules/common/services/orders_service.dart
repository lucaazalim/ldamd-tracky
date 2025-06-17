import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:mobile/modules/common/data/enum/order_status.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:mobile/modules/common/services/user_service.dart';
import 'package:mobile/modules/common/services/database_service.dart';
import 'package:mobile/modules/common/dio.dart';

/// A service that provides operations related to orders.
///
/// This service includes methods to fetch orders for customers and drivers from mock data files.
///


class OrdersService {

  final  dioClient = DioClient().dio;

  Future<Map<String, dynamic>> _loadMockData() async {
    final String response = await rootBundle.loadString('assets/mock/data.json');
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
        //print("driver: ${order.driver?.name}");

        order.costumer = await UserService().getUserById(order.customerId);
        //print("costumer: ${order.costumer?.name}");
      }
    } catch (e, stacktrace) {
      print("Error fetching users: $e");
      print(stacktrace);
    }


    return driverOrders;

  }

  Future<List<Order>> getAvailableOrders() async {
    try {
      final response = await dioClient.get(
        "/orders?status=PENDING",
        options: Options(
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJqYW1lc0BnbWFpbC5jb20iLCJpYXQiOjE3NTAxMTc3MzIsImV4cCI6MTc1MDIwNDEzMn0.ePzaA4oY78eibgm2pgf48wFUblOOOLNueP6C9gOF8AhAK9gyOkr10P2V4_EPzd1k5_CMXXXF84R14tYXbIiXHw",
          },
        ),
      );


      print(response.data);
      if((response.data as List).isEmpty){
       return [];
      }

      final orders = (response.data as List)
          .map((item) => Order.fromJson(item))
          .toList();

      return orders;

    } catch (e) {

      print('Erro ao buscar pedidos: $e');
      return []; // Retorna uma lista vazia pra não dar erro no App
    }

  }


  Future<Order?> updateOrderStatus(int orderId, XFile image, OrderStatus orderStatus) async {
    final dbHelper = DatabaseService();

    print("orderId: ${orderId}");

    await dbHelper.updateOrderStatusById(orderId, orderStatus);

    print("Status updated successfully!");

    if (image != null) {
      print("Captured image: ${image.path}");
    }

    OrderDTO? updatedOrder = await dbHelper.getOrderById(orderId);

    print('updatedOrder2 = ${updatedOrder?.status}');

    return null;

  }


}