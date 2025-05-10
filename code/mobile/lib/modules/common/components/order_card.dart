import 'package:flutter/material.dart';
import 'package:mobile/modules/common/data/order.dart'; // Assumindo que Order está aqui
import 'package:shared_preferences/shared_preferences.dart'; // Importe o SharedPreferences

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.local_shipping),
        title: Text('Order #${order.id}'),
        subtitle: Text(
          'Description: ${order.description}\n'
              'Address: ${order.address}',
        ),
        trailing: Text(
          order.status.name,
          style: TextStyle(
            color: _statusColor(order.status.name),
            fontWeight: FontWeight.bold,
          ),
        ),
        isThreeLine: true,
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          final userType = prefs.getString('type');

          if (userType == 'CUSTOMER') {
            Navigator.pushNamed(
              context,
              '/customer/order/details',
              arguments: order,
            );
          } else if (userType == 'DRIVER') {
            Navigator.pushNamed(
              context,
              '/driver/order/details',
              arguments: order,
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
        return Colors.red; // Aguardando
      case 'ACCEPTED':
        return Colors.blue; // Aceito
      case 'ON_COURSE':
        return Colors.orange; // Em andamento
      case 'DELIVERED':
        return Colors.green; // Entregue
      default:
        return Colors.grey; // Estado desconhecido
    }
  }
}

