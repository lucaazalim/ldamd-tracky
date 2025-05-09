import 'package:flutter/material.dart';
import 'package:mobile/modules/common/data/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.local_shipping),
        title: Text('Pedido #${order.id}'),
        subtitle: Text(
          'Descrição: ${order.description}\n'
              'Endereço: ${order.address}',
        ),
        trailing: Text(
          order.status.name,
          style: TextStyle(
            color: _statusColor(order.status.name),
            fontWeight: FontWeight.bold,
          ),
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.pushNamed(
            context,
            '/driver/order/details', // "/driver/order/update-status" both screens need an orders as arguments
            arguments: order,
          );
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