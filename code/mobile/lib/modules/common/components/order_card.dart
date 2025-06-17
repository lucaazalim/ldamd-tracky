import 'package:flutter/material.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const OrderCard({super.key, required this.order, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.local_shipping),
        title: Text('Order #${order.id}'),
        subtitle: Text(
          'Description: ${order.description}\n'
              'Destination Address: ${order.destinationAddress}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: _statusColor(order.status.name), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order.status.name,
                style: TextStyle(
                  color: _statusColor(order.status.name),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (onEdit != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
                tooltip: 'Edit order',
              ),
            ],
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
                tooltip: 'Delete order',
              ),
            ],
          ],
        ),
        isThreeLine: true,
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          final userType = prefs.getString('type');

          if (userType == 'CUSTOMER') {
            Navigator.pushNamed(
              context,
              '/customer/order/details',
              arguments: order.id,
            );
          } else if (userType == 'DRIVER') {
            Navigator.pushNamed(
              context,
              '/driver/order/details',
              arguments: order.id, // Passa apenas o ID, igual ao customer
            );
          } else {
            print('User type not found.');
          }
        },
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.red;
      case 'ACCEPTED':
        return Colors.blue;
      case 'ON_COURSE':
        return Colors.orange;
      case 'DELIVERED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}