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
      onWillPop: () async => false,

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
          automaticallyImplyLeading: false,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<List<Order>>(
                  future: _currentOrders,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ));
                    } else if (snapshot.hasError) {
                      return Text('Erro ao carregar as entregas: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('Nenhuma entrega pendente.');
                    } else {
                      return ListView.builder(
                        shrinkWrap: true, // <- importante para funcionar dentro do Column
                        physics: const NeverScrollableScrollPhysics(), // <- evita conflito de scrolls
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final order = snapshot.data![index];
                          return OrderCard(order: order);
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Entregas Concluídas',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                FutureBuilder<List<Order>>(
                  future: _completedOrders,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ));
                    } else if (snapshot.hasError) {
                      return Text('Erro ao carregar as entregas: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('Nenhuma entrega concluída.');
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final order = snapshot.data![index];
                          return OrderCard(order: order);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      ),
    );
  }
}