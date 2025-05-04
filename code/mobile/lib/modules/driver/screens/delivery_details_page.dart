import 'package:flutter/material.dart';
import 'package:mobile/modules/common/data/delivery.dart';

class DeliveryDetailsScreen extends StatelessWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Delivery) {
      return const Scaffold(
        body: Center(child: Text('Dados da entrega não fornecidos.')),
      );
    }

    final delivery = args as Delivery;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Entrega')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pedido: ${delivery.orderId}', style: const TextStyle(fontSize: 18)),
            Text('Destinatário: ${delivery.recipientName}'),
            Text('Endereço: ${delivery.address.street}, ${delivery.address.city}'),
            Text('Status: ${delivery.status}'),
            const SizedBox(height: 16),
            Text('Data de Entrega: ${delivery.deliveryDate}'),
          ],
        ),
      ),
    );
  }
}