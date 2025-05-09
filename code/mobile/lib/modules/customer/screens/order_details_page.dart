import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator
import 'package:mobile/modules/common/services/location_service.dart'; // Import your LocationService
import '../../../theme_provider.dart';
import 'package:mobile/modules/common/data/order.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState(); // Use StatefulWidget
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final LocationService _locationService = LocationService();
  Position? _position;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getLocation(); // Call _getLocation in initState
  }

  Future<void> _getLocation() async {
    try {
      final pos = await _locationService.getCurrentLocation();
      setState(() {
        _position = pos;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final order = ModalRoute.of(context)?.settings.arguments as Order?;

    if (order == null) {
      return const Scaffold(
        body: Center(
          child: Text('Order data not provided.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        titleTextStyle: TextStyle(
          color: const Color(0xFFBFF205),
          fontSize: 20.0,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Order ID: ${order.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Customer ID: ${order.customerId}'),
            const SizedBox(height: 8),
            Text('Address: ${order.address}',),
            const SizedBox(height: 8),
            Text('Description: ${order.description}'),
            const SizedBox(height: 8),
            Text('Order Status: ${order.status.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(order.status.name),
                )),
            const SizedBox(height: 16),
            if (order.imageUrl != null && order.imageUrl.isNotEmpty) ...[
              const Text(
                'Order Image:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Image.network(
                order.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ],
            const Divider(height: 32),
            const Text('Your Current Location:', style: TextStyle(fontWeight: FontWeight.bold)), // Changed text for customer
            if (_position != null)
              Text('Latitude: ${_position!.latitude}\nLongitude: ${_position!.longitude}'),
            if (_error != null)
              Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            if (_position == null && _error == null)
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.red;
      case 'ACCEPTED':
        return Colors.blue;
      case 'ON_COURSE':
        return Colors.orange;
      case 'DELIVERED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

