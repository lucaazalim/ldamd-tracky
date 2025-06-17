import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/components/theme_provider.dart';
import '../../common/components/bottom_bar.dart';
import '../../common/services/orders_service.dart';
import 'package:mobile/modules/common/data/order.dart';
import '../../common/components/order_card.dart';

/// A page that displays a list of orders for the customer.
///
/// This page fetches and displays orders asynchronously, allowing the user to view their order history.
class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrdersService _ordersService = OrdersService();
  // We no longer need 'late' here, as it will be initialized in initState
  // FutureBuilder will handle the state of this Future
  Future<List<Order>>? _ordersFuture; // Made nullable in case CustomerID cannot be loaded immediately

  // The _customerId variable is only used inside the asynchronous method,
  // so we can initialize it there or not make it a Late state variable at all
  // late int _customerId; // No longer needed as a late state variable

  @override
  void initState() {
    super.initState();
    // Call the method that fetches the data and assign the returned Future to _ordersFuture
    // This ensures _ordersFuture has a valid Future (that will still complete) from the start
    _ordersFuture = _fetchOrdersForCustomer();
  }

  // Renamed the method to indicate that it fetches and returns the Future
  Future<List<Order>> _fetchOrdersForCustomer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // We obtain the customerId here
      final String customerId = prefs.getString('userId') ?? "";

      if (customerId == 0) {
        // If customerId is 0, we return an empty list directly
        return [];
      } else {
        // Otherwise, we fetch the orders
        final List<Map<String, dynamic>> ordersData = await _ordersService.getOrdersForCustomer(customerId);
        final List<Order> orders = ordersData.map((orderMap) => Order.fromJson(orderMap)).toList();
        return orders;
      }
    } catch (e) {
      // We capture any error during the fetch and throw it as a Future.error
      // The FutureBuilder will capture this error in snapshot.hasError
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
        // We use the _ordersFuture that was initialized in initState
        // The FutureBuilder will manage the states (waiting, hasData, hasError)
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display the error message captured by the FutureBuilder
            return Center(child: Text('Error loading orders: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final orders = snapshot.data!;
            if (orders.isEmpty) {
              return const Center(child: Text('No orders found.')); // Adjusted message
            }
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                // Uses the reused OrderCard
                return OrderCard(
                  order: order,

                );
              },
            );
          } else {
            // This case (snapshot has no error, no data, and is not waiting)
            // generally does not occur with FutureBuilder when the Future is provided in initState,
            // but we can keep a fallback.
            return const Center(child: Text('Loading orders...'));
          }
        },
      ),
      // Assuming BottomNavBar has the correct index for this page
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}