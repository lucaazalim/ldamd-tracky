import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/modules/common/data/delivery.dart';
import 'package:mobile/modules/common/services/location_service.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
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

    if (args == null || args is! Delivery) {
      return const Scaffold(
        body: Center(child: Text('Dados da entrega não fornecidos.')),
      );
    }

    final delivery = args;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Entrega')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Pedido: ${delivery.orderId}', style: const TextStyle(fontSize: 18)),
            Text('Destinatário: ${delivery.recipientName}'),
            Text('Endereço: ${delivery.address.street}, ${delivery.address.city}'),
            Text('Status: ${delivery.status}'),
            const SizedBox(height: 16),
            Text('Data de Entrega: ${delivery.deliveryDate}'),
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