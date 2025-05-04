import 'package:flutter/material.dart';
import 'package:mobile/modules/common/data/delivery.dart';

class DeliveryCard extends StatelessWidget {
  final Delivery delivery;

  const DeliveryCard({super.key, required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.local_shipping),
        title: Text('Pedido: ${delivery.orderId}'),
        subtitle: Text(
          'Destinatário: ${delivery.recipientName}\n'
              'Endereço: ${delivery.address.street}, ${delivery.address.city}',
        ),
        trailing: Text(
          delivery.status,
          style: TextStyle(
            color: _statusColor(delivery.status),
            fontWeight: FontWeight.bold,
          ),
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.pushNamed(
            context,
            '/driver/delivery/details',
            arguments: delivery,
          );
        },
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}