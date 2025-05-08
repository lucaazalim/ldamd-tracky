import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../theme_provider.dart';
import "../common/bottom_bar.dart";
import '../../common/services/orders_service.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrdersService _ordersService = OrdersService();
  late Future<List<Map<String, dynamic>>> _ordersFuture;
  late int _customerId;

  @override
  void initState() {
    super.initState();
    _loadCustomerId();
  }

  Future<void> _loadCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    _customerId = prefs.getInt('userId') ?? 0;
    _ordersFuture = _ordersService.getOrdersForCustomer(_customerId);
    if (mounted) {
      setState(() {});
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os pedidos: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  leading: Icon(Icons.local_shipping, color: themeProvider.isDarkMode ? Colors.white : Colors.black,),
                  title: Text('ID do Pedido: ${order['id']}',
                      style: TextStyle(
                        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                      )),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${order['status']}',
                          style: TextStyle(
                            color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
                          )),
                      Text('Endereço: ${order['address']}',
                          style: TextStyle(
                            color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
                          )),
                      Text('Descrição: ${order['description']}',
                          style: TextStyle(
                            color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
                          )),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhum pedido encontrado.'));
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}

