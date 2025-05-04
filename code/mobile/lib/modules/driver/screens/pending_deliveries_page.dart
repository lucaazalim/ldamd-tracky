import 'package:flutter/material.dart';
import 'package:mobile/modules/common/data/address.dart';
import 'package:mobile/modules/common/data/delivery.dart';
import 'package:mobile/modules/driver/common/bottom_bar.dart';
import 'package:mobile/modules/driver/common/delivery_card.dart';

class PendingDeliveriesScreen extends StatelessWidget {
  const PendingDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Impede voltar
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Entregas Pendentes'),
          automaticallyImplyLeading: false, // Remove botão de voltar da AppBar
        ),
        body: mockDeliveries.isEmpty
            ? const Center(child: Text('Nenhuma entrega pendente.'))
            : ListView.builder(
          itemCount: mockDeliveries.length,
          itemBuilder: (context, index) {
            final delivery = mockDeliveries[index];
            return DeliveryCard(delivery: delivery);
          },
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: 1),
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

final List<Delivery> mockDeliveries = [
  Delivery(
    deliveryId: 'D001',
    orderId: 'O123',
    driverId: 'DR001',
    recipientName: 'João Silva',
    address: Address(
      street: 'Rua das Flores',
      number: '123',
      district: 'Centro',
      city: 'Belo Horizonte',
      state: 'MG',
      zipCode: '30130-000',
      latitude: -19.9208,
      longitude: -43.9378,
    ),
    deliveryDate: DateTime.now(),
    status: 'pending',
  ),
  Delivery(
    deliveryId: 'D002',
    orderId: 'O124',
    driverId: 'DR001',
    recipientName: 'Maria Oliveira',
    address: Address(
      street: 'Av. Afonso Pena',
      number: '1000',
      district: 'Funcionários',
      city: 'Belo Horizonte',
      state: 'MG',
      zipCode: '30130-003',
      latitude: -19.9245,
      longitude: -43.9352,
    ),
    deliveryDate: DateTime.now().add(const Duration(days: 1)),
    status: 'delivered',
  ),
  Delivery(
    deliveryId: 'D003',
    orderId: 'O125',
    driverId: 'DR001',
    recipientName: 'Carlos Souza',
    address: Address(
      street: 'Rua Bahia',
      number: '500',
      district: 'Lourdes',
      city: 'Belo Horizonte',
      state: 'MG',
      zipCode: '30160-010',
      latitude: -19.9281,
      longitude: -43.9411,
    ),
    deliveryDate: DateTime.now().add(const Duration(days: 2)),
    status: 'cancelled',
  ),
];