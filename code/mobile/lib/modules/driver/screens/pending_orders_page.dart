import 'package:flutter/material.dart';
import 'package:mobile/modules/common/services/orders_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile/modules/common/data/enum/order_status.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:mobile/modules/common/data/location.dart';
import '../../common/components/bottom_bar.dart';
import 'package:mobile/modules/driver/common/order_card.dart';
import '../../../theme_provider.dart';

class PendingOrdersScreen extends StatefulWidget {
  const PendingOrdersScreen({super.key});

  @override
  State<PendingOrdersScreen> createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
  late Future<List<Order>> _currentOrders;
  late Future<List<Order>> _completedOrders;

  @override
  void initState() {
    super.initState();
    _currentOrders = _loadPendingOrders();
    _completedOrders = _loadCompletedOrders();
  }

  Future<List<Order>> _loadPendingOrders() async {
    final currentOrders = OrdersService().getCurrentOrdersByDriverId(2);
    return currentOrders;
  }

  Future<List<Order>> _loadCompletedOrders() async {
    final currentOrders = OrdersService().getCompletedOrdersByDriverId(2);
    return currentOrders;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return WillPopScope(
      onWillPop: () async => false, // Impede voltar
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Entregas Pendentes'),
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
          automaticallyImplyLeading: false, // Remove botão de voltar da AppBar
        ),
        body:
        FutureBuilder<List<Order>>(
          future: _currentOrders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar as entregas: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma entrega pendente.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final order = snapshot.data![index];
                  return OrderCard(order: order);
                },
              );
            }
          },
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      ),
    );
  }
}