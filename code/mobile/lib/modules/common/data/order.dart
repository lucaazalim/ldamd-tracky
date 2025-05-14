import 'package:mobile/modules/common/data/enum/order_status.dart';
import 'package:mobile/modules/common/data/user.dart';

/// A model representing an order in the system.
///
/// This class includes details such as the order ID, customer and driver IDs, status, address, description, and image URL.
/// It also provides methods for JSON serialization and deserialization.
class Order {
  final int id;
  final int customerId;
  final int driverId;
  final OrderStatus status;
  final String address;
  final String description;
  final String imageUrl;
  User? costumer;
  User? driver;

  Order({
    required this.id,
    required this.customerId,
    required this.driverId,
    required this.status,
    required this.address,
    required this.description,
    required this.imageUrl,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customer_id'],
      driverId: json['driver_id'],
      status: OrderStatus.fromString(json['status']),
      address: json['address'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'driver_id': driverId,
      'status': status.toJson(),
      'address': address,
      'description': description,
      'image_url': imageUrl,
    };
  }
}