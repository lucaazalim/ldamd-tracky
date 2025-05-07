import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/modules/common/data/location.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:mobile/modules/common/services/location_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final LocationService _locationService = LocationService();
  Position? _position;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getLocation();
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
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Order) {
      return const Scaffold(
        body: Center(child: Text('Dados da entrega não fornecidos.')),
      );
    }

    final order = args as Order;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Pedido ID: ${order.id}', style: const TextStyle(fontSize: 18)),
            Text('Cliente: ${order.customerId}'),
            Text('Motorista: ${order.driverId}'),
            Text('Endereço: ${order.address}'),
            Text('Descrição: ${order.description}'),
            Text('Status: ${order.status}'),
            const SizedBox(height: 16),
            if (order.imageUrl != null && order.imageUrl.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Imagem do Pedido:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Image.network(order.imageUrl, height: 150),
                ],
              ),
            const Divider(height: 32),
            const Text('Sua localização atual:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (_position != null)
              Text('Latitude: ${_position!.latitude}\nLongitude: ${_position!.longitude}'),
            if (_error != null)
              Text('Erro: $_error', style: const TextStyle(color: Colors.red)),
            if (_position == null && _error == null)
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );

  }

}