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
  Future<List<Order>>?
  _ordersFuture; // Made nullable in case CustomerID cannot be loaded immediately

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
        final List<Order> ordersData = await _ordersService
            .getOrdersForCustomer(customerId);
        return ordersData;
      }
    } catch (e) {
      throw e; // Throws the error to the FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 5, 242, 112), // seta verde
        ),
        titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 5, 242, 112),
          fontSize: 24.0,
        ),
        backgroundColor: Colors.black,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 5, 242, 112),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  minimumSize: const Size.fromHeight(46),
                ),
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text(
                  'New Order',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/customer/order/form',
                  );
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
                  return Center(
                    child: Text('Error loading orders: \\${snapshot.error}'),
                  );
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
                            builder:
                                (ctx) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                    'Are you sure that you wanna delete this order?',
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Color.fromARGB(
                                            255,
                                            5,
                                            242,
                                            112,
                                          ),
                                          width: 2,
                                        ),
                                        foregroundColor: Color.fromARGB(
                                          255,
                                          5,
                                          242,
                                          112,
                                        ),
                                      ),
                                      onPressed:
                                          () => Navigator.pop(ctx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          5,
                                          242,
                                          112,
                                        ),
                                        foregroundColor: Colors.black,
                                      ),
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                          );
                          if (confirm == true) {
                            final success = await _ordersService.deleteOrder(
                              order.id,
                            );
                            if (success) {
                              setState(() {
                                _ordersFuture = _fetchOrdersForCustomer();
                              });
                            }
                          }
                        },
                        onEdit: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder:
                                (ctx) => EditOrderDialog(
                                  order: order,
                                  onSave: (updatedOrder) async {
                                    final success = await _ordersService
                                        .updateOrder(order.id, updatedOrder);
                                    if (success != null) {
                                      Navigator.pop(ctx, true);
                                    }
                                  },
                                ),
                          );
                          if (result == true) {
                            setState(() {
                              _ordersFuture = _fetchOrdersForCustomer();
                            });
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

// Adiciona o widget EditOrderDialog abaixo da classe OrdersPage
class EditOrderDialog extends StatefulWidget {
  final Order order;
  final Future<void> Function(Map<String, dynamic>) onSave;
  const EditOrderDialog({Key? key, required this.order, required this.onSave})
    : super(key: key);

  @override
  State<EditOrderDialog> createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends State<EditOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _originController;
  late TextEditingController _destinationController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _originController = TextEditingController(text: widget.order.originAddress);
    _destinationController = TextEditingController(
      text: widget.order.destinationAddress,
    );
    _descriptionController = TextEditingController(
      text: widget.order.description,
    );
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final data = {
      'originAddress': _originController.text,
      'destinationAddress': _destinationController.text,
      'description': _descriptionController.text,
    };
    await widget.onSave(data);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Order'),
      content:
          _isLoading
              ? const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              )
              : Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _originController,
                      decoration: const InputDecoration(
                        labelText: 'Origin Address',
                      ),
                      validator:
                          (v) =>
                              v == null || v.isEmpty ? 'Required field' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _destinationController,
                      decoration: const InputDecoration(
                        labelText: 'Destination Address',
                      ),
                      validator:
                          (v) =>
                              v == null || v.isEmpty ? 'Required field' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator:
                          (v) =>
                              v == null || v.isEmpty ? 'Required field' : null,
                    ),
                  ],
                ),
              ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Color.fromARGB(255, 5, 242, 112),
              width: 2,
            ),
            foregroundColor: Color.fromARGB(255, 5, 242, 112),
          ),
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 5, 242, 112),
            foregroundColor: Colors.black,
          ),
          onPressed: _isLoading ? null : _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
