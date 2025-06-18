import 'package:flutter/material.dart';
import 'package:mobile/modules/common/data/enum/order_status.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:mobile/modules/common/services/orders_service.dart';

/// A page that allows drivers to update the status of an order.
///
/// This page includes a camera interface for capturing images and a dropdown to select the new status.
class UpdateOrderStatusPage extends StatefulWidget {
  const UpdateOrderStatusPage({super.key});

  @override
  State<UpdateOrderStatusPage> createState() => _UpdateOrderStatusPageState();
}

class _UpdateOrderStatusPageState extends State<UpdateOrderStatusPage> {
  OrderStatus? _selectedStatus;

  final List<OrderStatus> _statuses = OrderStatus.values;

  @override
  Widget build(BuildContext context) {

    //validating data passed on args;
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Order) {
      return const Scaffold(
        body: Center(child: Text('Delivery data not provided.')),
      );
    }

    final order = args;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Change Order Status'),
        titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 5, 242, 112),
          fontSize: 20.0,
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 5, 242, 112), 
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Container(
            color: Colors.black,
            height: 8,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Select New Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DropdownButton<OrderStatus>(
              value: _selectedStatus,
              hint: const Text('Choose a status'),
              isExpanded: true,
              onChanged: (OrderStatus? newValue) {
                setState(() {
                  _selectedStatus = newValue;
                });
              },
              items: _statuses.map((OrderStatus status) {
                return DropdownMenuItem<OrderStatus>(
                  value: status,
                  child: Text(status.displayName),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 5, 242, 112),
                padding: const EdgeInsets.symmetric(vertical: 10),
                minimumSize: const Size.fromHeight(46),
              ),
              icon: const Icon(Icons.check_circle, color: Colors.black),
              label: const Text(
                'Confirm Status Change',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              onPressed: () async {
                if (_selectedStatus == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a status')),
                  );
                  return;
                }

                try {
                  await OrdersService().updateOrderStatus(order.id, _selectedStatus!.name.toUpperCase());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Status changed to: ${_selectedStatus!.displayName}')),
                  );
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update status: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}