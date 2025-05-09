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
        onTap: () async {
          // *** AVISO: Esta não é a maneira recomendada de lidar com a navegação. ***
          // *** A lógica de navegação DEVE estar nas telas que usam OrderCard.    ***
          final prefs = await SharedPreferences.getInstance();
          final userType = prefs.getString('type'); // Obtém o tipo do usuário

          if (userType == 'CUSTOMER') {
            // *** AVISO: Navegação direta no componente dificulta a reusabilidade. ***
            Navigator.pushNamed(
              context,
              '/customer/order/details',
              arguments: order, //talvez precise passar o order
            );
          } else if (userType == 'DRIVER') {
            // *** AVISO: Navegação direta no componente dificulta a reusabilidade. ***
            Navigator.pushNamed(
              context, //duplicado
              '/driver/order/details', // Assumindo que esta é a rota correta
              arguments: order,
            );
          } else {
            // *** AVISO: Trate o caso em que o tipo de usuário é desconhecido ou nulo. ***
            print('Tipo de usuário desconhecido. Navegação não realizada.');
            // Você pode exibir uma mensagem de erro ou fazer outra ação apropriada aqui.
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

