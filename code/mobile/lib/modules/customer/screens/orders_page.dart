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
      body: FutureBuilder<List<Order>>(
      
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading orders: ${snapshot.error}'));
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

                );
              },
            );
          } else {
            
            return const Center(child: Text('Loading orders...'));
          }
        },
      ),
      // Assuming BottomNavBar has the correct index for this page
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}