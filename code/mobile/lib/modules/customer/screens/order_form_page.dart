import 'package:flutter/material.dart';
import 'package:mobile/modules/common/services/orders_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderFormPage extends StatefulWidget {
  const OrderFormPage({Key? key}) : super(key: key);

  @override
  State<OrderFormPage> createState() => _OrderFormPageState();
}

class _OrderFormPageState extends State<OrderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final customerId = prefs.getString('userId') ?? '';
    final data = {
      'customerId': customerId,
      'originAddress': _originController.text,
      'destinationAddress': _destinationController.text,
      'description': _descriptionController.text,
      'status': 'PENDING',
      'driverId': '',
      'image_url': '',
    };
    final order = await OrdersService().createOrder(data);
    setState(() => _isLoading = false);
    if (order != null && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('New Order'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Container(
            color: Colors.black,
            height: 8,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _originController,
                      decoration: const InputDecoration(labelText: 'Origin Address'),
                      validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _destinationController,
                      decoration: const InputDecoration(labelText: 'Destination Address'),
                      validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 5, 242, 112),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _submit,
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: const Text('Create Order', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}