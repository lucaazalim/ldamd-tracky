import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/components/theme_provider.dart';
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
  // Não precisamos mais de 'late' aqui, pois vamos inicializá-lo em initState
  // O FutureBuilder é quem vai lidar com o estado desse Future
  Future<List<Order>>? _ordersFuture; // Tornamos nullable caso não seja possível carregar o CustomerID imediatamente

  // A variável _customerId só é usada dentro do método assíncrono,
  // então podemos inicializá-la lá ou nem torná-la uma variável de estado Late
  // late int _customerId; // Não precisamos mais disso como late state variable

  @override
  void initState() {
    super.initState();
    // Chamamos o método que busca os dados e atribuímos o Future retornado a _ordersFuture
    // Isso garante que _ordersFuture tem um Future válido (que ainda vai completar) desde o início
    _ordersFuture = _fetchOrdersForCustomer();
  }

  // Renomeamos o método para indicar que ele busca e retorna o Future
  Future<List<Order>> _fetchOrdersForCustomer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Obtemos o customerId aqui dentro
      final int customerId = prefs.getInt('userId') ?? 0;

      if (customerId == 0) {
        // Se customerId for 0, retornamos uma lista vazia diretamente
        return [];
      } else {
        // Caso contrário, buscamos os pedidos
        final List<Map<String, dynamic>> ordersData = await _ordersService.getOrdersForCustomer(customerId);
        final List<Order> orders = ordersData.map((orderMap) => Order.fromJson(orderMap)).toList();
        return orders;
      }
    } catch (e) {
      // Capturamos qualquer erro durante a busca e lançamos como um Future.error
      // O FutureBuilder irá capturar este erro no snapshot.hasError
      print('Error fetching orders: $e'); // Opcional: logar o erro
      throw e; // Lança o erro para o FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        titleTextStyle: TextStyle(
            color: const Color(0xFFBFF205),
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
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Order>>(
        // Usamos o _ordersFuture que foi inicializado em initState
        // O FutureBuilder vai gerenciar os estados (waiting, hasData, hasError)
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Exibe a mensagem de erro capturada pelo FutureBuilder
            return Center(child: Text('Error loading orders: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final orders = snapshot.data!;
            if (orders.isEmpty) {
              return const Center(child: Text('No orders found.')); // Mensagem ajustada
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
            // Este caso (snapshot não tem erro, não tem data, e não está waiting)
            // geralmente não acontece com FutureBuilder quando o Future é fornecido em initState,
            // mas podemos manter um fallback.
            return const Center(child: Text('Loading orders...'));
          }
        },
      ),
      // Assumindo que BottomNavBar tem o índice correto para esta página
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}