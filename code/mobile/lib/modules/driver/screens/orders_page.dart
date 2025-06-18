import 'package:flutter/material.dart';
import 'package:mobile/modules/common/services/orders_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/components/bottom_bar.dart';
import 'package:mobile/modules/common/components/order_card.dart';
import '../../common/components/theme_provider.dart';

/// A page that displays pending and available orders for drivers.
///
/// This page fetches and displays orders asynchronously, allowing drivers to view and manage their deliveries.
class PendingOrdersScreen extends StatefulWidget {
  const PendingOrdersScreen({super.key});

  @override
  State<PendingOrdersScreen> createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> with RouteAware {
  late Future<List<Order>> _currentOrders;
  late Future<List<Order>> _availableOrders;
  RouteObserver<ModalRoute<void>>? _routeObserver;

  @override
  void initState() {
    super.initState();
    _currentOrders = _loadPendingOrders();
    _availableOrders = _loadAvailableOrders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver ??= ModalRoute.of(context)?.navigator?.widget.observers.whereType<RouteObserver<ModalRoute<void>>>().firstOrNull;
    _routeObserver?.subscribe(this, ModalRoute.of(context)!);
    _currentOrders = _loadPendingOrders();
    _availableOrders = _loadAvailableOrders();
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {
      _currentOrders = _loadPendingOrders();
      _availableOrders = _loadAvailableOrders();
    });
  }

  Future<List<Order>> _loadPendingOrders() async {

    try{
      final prefs = await SharedPreferences.getInstance();
      final String driverId = prefs.getString('userId') ?? "";

      if (driverId.isEmpty) {
        return [];
      } else {

        final List<Order> currentOrders = await OrdersService().getCurrentOrdersByDriverId(driverId);
        return currentOrders;

      }

    }catch(e){

      print('Error fetching orders: $e'); // Optional: log the error
      throw e; // Throws the error to the FutureBuilder

    }

  }


  Future<List<Order>> _loadAvailableOrders() async {
    final availableOrders = OrdersService().getAvailableOrders();
    return availableOrders;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return WillPopScope(
      onWillPop: () async => false,

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Orders'),
          iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 5, 242, 112), // seta verde
        ),
          titleTextStyle: TextStyle(
              color: const Color.fromARGB(255, 5, 242, 112),
              fontSize: 24.0
          ),
          bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Container(
            color: Colors.black,
            height: 8,
          ),
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
            padding: const EdgeInsets.all(1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Current Orders',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      ),
                    ),
                  ),
                ),
                FutureBuilder<List<Order>>(
                  future: _currentOrders,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ));
                    } else if (snapshot.hasError) {
                      return Text('Error loading deliveries: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No pending deliveries.'));
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
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Available Orders',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      ),
                    ),
                  ),
                ),
                FutureBuilder<List<Order>>(
                  future: _availableOrders,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ));
                    } else if (snapshot.hasError) {
                      return Text('Error loading deliveries: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No deliveries.'));
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