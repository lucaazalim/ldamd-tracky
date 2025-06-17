import 'package:mobile/modules/common/data/enum/order_status.dart';
import 'package:mobile/modules/common/data/user.dart';

/// A model representing an order in the system.
///
/// This class includes details such as the order ID, customer and driver IDs, status, address, description, and image URL.
/// It also provides methods for JSON serialization and deserialization.
class Order {
  final String id;
  final String customerId;
  final String driverId;
  final OrderStatus status;
  final String originAddress;
  final String destinationAddress;
  final String description;
  final String imageUrl;
  User? costumer;
  User? driver;

  Order({
    required this.id,
    required this.customerId,
    required this.driverId,
    required this.status,
    required this.destinationAddress,
    required this.originAddress,
    required this.description,
    required this.imageUrl,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customerId'],
      driverId: json['driverId'],
      status: OrderStatus.fromString(json['status']),
      destinationAddress: json['destinationAddress'],
      originAddress: json['originAddress'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'driverId': driverId,
      'status': status.toJson(),
      'originAddress': originAddress,
      'destinationAddress': destinationAddress,
      'description': description,
      'image_url': imageUrl,
    };
  }
}