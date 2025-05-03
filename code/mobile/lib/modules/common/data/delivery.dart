import 'package:mobile/modules/common/data/address.dart';

class Delivery {
  final String deliveryId;
  final String orderId;
  final String driverId;
  final String recipientName;
  final Address address;
  final DateTime deliveryDate;
  final String status;

  Delivery({
    required this.deliveryId,
    required this.orderId,
    required this.driverId,
    required this.recipientName,
    required this.address,
    required this.deliveryDate,
    required this.status,
  });
}