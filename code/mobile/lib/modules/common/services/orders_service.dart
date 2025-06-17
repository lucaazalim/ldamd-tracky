import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:mobile/modules/common/data/enum/order_status.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:mobile/modules/common/dio.dart';

class OrdersService {
  final dioClient = DioClient().dio;

  Future<List<Order>> getOrdersForCustomer(String customerId) async {
    try {
      final response = await dioClient.get(
        "/orders?customer=$customerId",
      );

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
      );
      return Order.fromJson(response.data);
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
      );

      return Order.fromJson(response.data);
    } catch (e) {
      print('Erro ao atualizar pedido: $e');
      return null;
    }
  }

  Future<Order?> createOrder(Map<String, dynamic> data) async {
    try {
      final response = await dioClient.post(
        "/orders",
        data: data,
      );
      return Order.fromJson(response.data);
    } catch (e) {
      print('Erro ao criar pedido: $e');
      return null;
    }
  }

  Future<Order?> updateOrder(String id, Map<String, dynamic> data) async {
    try {
      final response = await dioClient.put(
        "/orders/$id",
        data: data,
      );
      return Order.fromJson(response.data);
    } catch (e) {
      print('Erro ao editar pedido: $e');
      return null;
    }
  }

  Future<bool> deleteOrder(String id) async {
    try {
      await dioClient.delete("/orders/$id");
      return true;
    } catch (e) {
      print('Erro ao deletar pedido: $e');
      return false;
    }
  }
}