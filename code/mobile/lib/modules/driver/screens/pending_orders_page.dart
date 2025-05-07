import 'package:flutter/material.dart';
import 'package:mobile/modules/common/data/enum/order_status.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:mobile/modules/common/data/location.dart';
import 'package:mobile/modules/driver/common/bottom_bar.dart';
import 'package:mobile/modules/driver/common/order_card.dart';

class PendingOrdersScreen extends StatelessWidget {
  const PendingOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Impede voltar
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Entregas Pendentes'),
          automaticallyImplyLeading: false, // Remove botão de voltar da AppBar
        ),
        body: mockOrders.isEmpty
            ? const Center(child: Text('Nenhuma entrega pendente.'))
            : ListView.builder(
          itemCount: mockOrders.length,
          itemBuilder: (context, index) {
            final order = mockOrders[index];
            return OrderCard(order: order);
          },
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: 1),
      ),
    );
  }

}


final List<Order> mockOrders = [
  Order(
    id: 1,
    customerId: 101,
    driverId: 201,
    status: OrderStatus.accepted,
    address: 'Rua das Flores, 123 - Centro, Belo Horizonte - MG',
    description: 'Entrega de utensílios domésticos',
    imageUrl: 'https://example.com/images/order1.png',
  ),
  Order(
    id: 2,
    customerId: 102,
    driverId: 201,
    status: OrderStatus.delivered,
    address: 'Av. Afonso Pena, 1000 - Funcionários, Belo Horizonte - MG',
    description: 'Pacote de ferramentas manuais',
    imageUrl: 'https://example.com/images/order2.png',
  ),
  Order(
    id: 3,
    customerId: 103,
    driverId: 201,
    status: OrderStatus.onCourse,
    address: 'Rua Bahia, 500 - Lourdes, Belo Horizonte - MG',
    description: 'Itens de pesca e camping',
    imageUrl: 'https://example.com/images/order3.png',
  ),
  Order(
    id: 4,
    customerId: 104,
    driverId: 202,
    status: OrderStatus.onCourse,
    address: 'Rua Timbiras, 750 - Funcionários, Belo Horizonte - MG',
    description: 'Decoração para eventos',
    imageUrl: 'https://example.com/images/order4.png',
  ),
];