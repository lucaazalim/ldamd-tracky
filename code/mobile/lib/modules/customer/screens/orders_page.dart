import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../theme_provider.dart';
import '../../common/components/bottom_bar.dart';
import '../../common/services/orders_service.dart';
import 'package:mobile/modules/common/data/order.dart';
import '../../common/components/order_card.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrdersService _ordersService = OrdersService();
  late Future<List<Order>> _ordersFuture;
  late int _customerId;

  @override
  void initState() {
    super.initState();

    _loadCustomerIdAndOrders();
  }

  Future<void> _loadCustomerIdAndOrders() async {
    final prefs = await SharedPreferences.getInstance();
    _customerId = prefs.getInt('userId') ?? 0;

    if (_customerId == 0) {

      _ordersFuture = Future.value([]);
    } else {
      try {
        final List<Map<String, dynamic>> ordersData = await _ordersService.getOrdersForCustomer(_customerId);

        final List<Order> orders = ordersData.map((orderMap) => Order.fromJson(orderMap)).toList();

        _ordersFuture = Future.value(orders);

      } catch (e) {

        _ordersFuture = Future.error(e); // Define o future com o erro
      }
    }


    if (mounted) {
      setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'), // Título mais específico para o cliente
        titleTextStyle: TextStyle(
            color: const Color(0xFFBFF205), // Exemplo de cor da sua AppBar
            fontSize: 20.0
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.brightness_2 : Icons.wb_sunny,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
        automaticallyImplyLeading: false, // Remove o botão voltar padrão
      ),
      body: FutureBuilder<List<Order>>( // O FutureBuilder espera List<Order>
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Exibe a mensagem de erro capturada
            return Center(child: Text('Erro ao carregar os pedidos: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final orders = snapshot.data!;
            if (orders.isEmpty) {
              return const Center(child: Text('Nenhum pedido encontrado.'));
            }
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                // Usa o OrderCard reutilizado
                return OrderCard(
                  order: order,

                );
              },
            );
          } else {
            return const Center(child: Text('Carregando pedidos...')); // Ou outro indicador
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0), // Assumindo que esta é a primeira tab
    );
  }
}