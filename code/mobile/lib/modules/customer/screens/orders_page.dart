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
  Future<List<Order>>? _ordersFuture; // Made nullable in case CustomerID cannot be loaded immediately


  @override
  void initState() {
    super.initState();
    
    _ordersFuture = _fetchOrdersForCustomer();
  }

  Future<List<Order>> _fetchOrdersForCustomer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String customerId = prefs.getString('userId') ?? "";

      if (customerId.isEmpty) {
        return [];
      } else {
        final List<Order> ordersData = await _ordersService.getOrdersForCustomer(customerId);
        return ordersData;
      }
    } catch (e) {
      
      print('Error fetching orders: $e'); // Optional: log the error
      throw e; // Throws the error to the FutureBuilder
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('New Order'),
                onPressed: () async {
                  final result = await Navigator.pushNamed(context, '/customer/order/form');
                  if (result == true) {
                    setState(() {
                      _ordersFuture = _fetchOrdersForCustomer();
                    });
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Order>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading orders: \\${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final orders = snapshot.data!;
                  if (orders.isEmpty) {
                    return const Center(child: Text('No orders found.'));
                  }
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return OrderCard(
                        order: order,
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm delete'),
                              content: const Text('Are you sure that you wanna delete this order?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            final success = await _ordersService.deleteOrder(order.id);
                            if (success) {
                              setState(() {
                                _ordersFuture = _fetchOrdersForCustomer();
                              });
                            }
                          }
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Loading orders...'));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}