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
  final dioClient = DioClient().dio;

  Future<List<Order>> getOrdersForCustomer(String customerId) async {
    try {
      final response = await dioClient.get(
        "/orders?driver=$customerId",
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJqYW1lc0BnbWFpbC5jb20iLCJpYXQiOjE3NTAxMTc3MzIsImV4cCI6MTc1MDIwNDEzMn0.ePzaA4oY78eibgm2pgf48wFUblOOOLNueP6C9gOF8AhAK9gyOkr10P2V4_EPzd1k5_CMXXXF84R14tYXbIiXHw",
          },
        ),
      );

      print(response.data);
      if ((response.data as List).isEmpty) {
        return [];
      }

      final orders =
          (response.data as List).map((item) => Order.fromJson(item)).toList();

      return orders;
    } catch (e) {
      print('Error loading orders: $e');

      return [];
    }
  }

  Future<List<Order>> getCurrentOrdersByDriverId(String driverId) async {
    try {
      final response = await dioClient.get(
        "/orders?driver=$driverId",
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJqYW1lc0BnbWFpbC5jb20iLCJpYXQiOjE3NTAxMTc3MzIsImV4cCI6MTc1MDIwNDEzMn0.ePzaA4oY78eibgm2pgf48wFUblOOOLNueP6C9gOF8AhAK9gyOkr10P2V4_EPzd1k5_CMXXXF84R14tYXbIiXHw",
          },
        ),
      );

      print(response.data);
      if ((response.data as List).isEmpty) {
        return [];
      }

      final orders =
          (response.data as List).map((item) => Order.fromJson(item)).toList();

      return orders;
    } catch (e) {
      print('Erro ao buscar pedidos: $e');

      return [];
    }
  }

  Future<List<Order>> getAvailableOrders() async {
    try {
      final response = await dioClient.get(
        "/orders?status=PENDING",
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJqYW1lc0BnbWFpbC5jb20iLCJpYXQiOjE3NTAxMTc3MzIsImV4cCI6MTc1MDIwNDEzMn0.ePzaA4oY78eibgm2pgf48wFUblOOOLNueP6C9gOF8AhAK9gyOkr10P2V4_EPzd1k5_CMXXXF84R14tYXbIiXHw", //mudar
          },
        ),
      );

      print(response.data);
      if ((response.data as List).isEmpty) {
        return [];
      }

      final orders =
          (response.data as List).map((item) => Order.fromJson(item)).toList();

      return orders;
    } catch (e) {
      print('Erro ao buscar pedidos: $e');
      return []; // Retorna uma lista vazia pra não dar erro no App
    }
  }

  Future<Order?> getOrderById(String orderId) async {
    try {
      final response = await dioClient.get(
        "/orders/$orderId",
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJqYW1lc0BnbWFpbC5jb20iLCJpYXQiOjE3NTAxMTc3MzIsImV4cCI6MTc1MDIwNDEzMn0.ePzaA4oY78eibgm2pgf48wFUblOOOLNueP6C9gOF8AhAK9gyOkr10P2V4_EPzd1k5_CMXXXF84R14tYXbIiXHw", //mudar
          },
        ),
      );

      return response.data;
    } catch (e) {
      print('Erro ao buscar pedidos: $e');

      return null;
    }
  }

  Future<Order?> updateOrderStatus(
    String orderId,
    XFile image,
    OrderStatus orderStatus,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path),
        'status': orderStatus.toString(), // ou o que seu backend espera
      });

      final response = await dioClient.put(
        "/orders/$orderId",
        data: formData,
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJqYW1lc0BnbWFpbC5jb20iLCJpYXQiOjE3NTAxMTc3MzIsImV4cCI6MTc1MDIwNDEzMn0.ePzaA4oY78eibgm2pgf48wFUblOOOLNueP6C9gOF8AhAK9gyOkr10P2V4_EPzd1k5_CMXXXF84R14tYXbIiXHw", //mudar
          },
        ),
      );

      return Order.fromJson(response.data);
    } catch (e) {
      print('Erro ao atualizar pedido: $e');
      return null;
    }
  }
}
