import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart'; 
import 'package:mobile/modules/common/services/tracking_service.dart';
import 'package:mobile/modules/common/services/orders_service.dart';
import 'package:mobile/modules/common/data/tracking.dart';
import '../../common/components/theme_provider.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' show locationFromAddress, Location;
import 'package:open_route_service/open_route_service.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final TrackingService _orderLocationService = TrackingService();
  final OrdersService _ordersService = OrdersService();

  Tracking? _orderLocation;
  bool _isLoadingOrderLocation = true;
  String? _orderLocationError;

  Timer? _trackingTimer;
  Timer? _orderLocationPollingTimer;

  Order? _order;
  bool _isLoadingOrder = true;
  String? _orderError;

  List<Marker> _markers = [];
  List<Polyline> _polylines = [];
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrder();
    });
  }

  void _startOrderLocationPolling() {
    _orderLocationPollingTimer?.cancel();
    _orderLocationPollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (_order != null && _order!.status.name.toUpperCase() == 'ON_COURSE') {
        await _fetchOrderLocation();
      } else {
        timer.cancel();
      }
    });
  }

  void _stopOrderLocationPolling() {
    _orderLocationPollingTimer?.cancel();
  }

  Future<void> _fetchOrderLocation() async {
    if (_order == null) {
      setState(() {
        _orderLocationError = 'Order data not provided.';
        _isLoadingOrderLocation = false;
      });
      return;
    }
    try {
      final location = await _orderLocationService.getLatestLocationForOrder(_order!.id);
      setState(() {
        _orderLocation = location;
        _isLoadingOrderLocation = false;
        if (location != null) {
          _addOrderMarker(location);
        } else {
          _orderLocationError = 'Location data not available for this order.';
        }
      });
      if (location != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _mapController.move(LatLng(location.latitude, location.longitude), 13.0);
          }
        });
        // Calcula rota do motorista até o destino
        await _fetchRouteToDestination(location);
      }
    } catch (e) {
      setState(() {
        _orderLocationError = 'Error fetching order location: \\${e.toString()}';
        _isLoadingOrderLocation = false;
      });
    }
  }

Future<LatLng?> addressToLatLng(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      return LatLng(locations.first.latitude, locations.first.longitude);
    }
  } catch (e) {
    print('Erro ao converter endereço: $e');
  }
  return null;
}

Future<void> _fetchRouteToDestination(Tracking driverLocation) async {
  if (_order == null) return;

  // Usa o endereço do pedido, não do tracking
  final originLatLng = await addressToLatLng(_order!.originAddress);
  final destLatLng = await addressToLatLng(_order!.destinationAddress);

  if (originLatLng != null && destLatLng != null) {
    try {
      final client = OpenRouteService(apiKey: 'SUA_API_KEY'); // Substitua pela sua API KEY
      final List<ORSCoordinate> routeCoordinates = await client.directionsRouteCoordsGet(
        startCoordinate: ORSCoordinate(latitude: originLatLng.latitude, longitude: originLatLng.longitude),
        endCoordinate: ORSCoordinate(latitude: destLatLng.latitude, longitude: destLatLng.longitude),
        profileOverride: ORSProfile.drivingCar,
      );
      final routePoints = routeCoordinates.map((coord) => LatLng(coord.latitude, coord.longitude)).toList();
      setState(() {
        _polylines = [Polyline(points: routePoints, strokeWidth: 4.0, color: Colors.blue)];
      });
    } catch (e) {
      print('Erro ao buscar rota: $e');
    }
  }
}

  Future<void> _fetchOrder() async {
    final orderId = ModalRoute.of(context)?.settings.arguments as String?;
    if (orderId == null) {
      setState(() {
        _orderError = 'Order ID not provided.';
        _isLoadingOrder = false;
      });
      return;
    }
    try {
      final orderData = await _ordersService.getOrderById(orderId);
      setState(() {
        _order = orderData;
        _isLoadingOrder = false;
      });
      if (_order != null) {
        await _fetchOrderLocation();
        if (_order!.status.name.toUpperCase() == 'ON_COURSE') {
          _startOrderLocationPolling();
        } else {
          _stopOrderLocationPolling();
        }
      }
    } catch (e) {
      setState(() {
        _orderError = 'Error fetching order: \\${e.toString()}';
        _isLoadingOrder = false;
      });
    }
  }


  void _addOrderMarker(Tracking location) {
    final marker = Marker(
      point: LatLng(location.latitude, location.longitude), 
      width: 80, 
      height: 80, 
      child: Icon(
        Icons.location_pin, 
        color: Colors.red, 
        size: 40,
      ),

    );

    setState(() {
      _markers = [marker]; 
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (_isLoadingOrder) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_orderError != null) {
      return Scaffold(
        body: Center(child: Text(_orderError!, style: TextStyle(color: Colors.red))),
      );
    }
    if (_order == null) {
      return const Scaffold(
        body: Center(child: Text('Order not found.')),
      );
    }
    final order = _order!;

    // Default initial camera position if order location is not yet loaded
    final LatLng _initialMapCenter = LatLng(_orderLocation?.latitude ?? -19.9208, _orderLocation?.longitude ?? -43.9378); // Defaulting to a known location if _orderLocation is null initially
    const double _initialMapZoom = 13.0;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 5, 242, 112), // seta verde
        ),
        title: const Text('Order Details'),
        titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 5, 242, 112),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Container(
            color: Colors.black,
            height: 8,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Order: ${order.id.substring(0,5)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Origin address: ${order.originAddress}',),
            const SizedBox(height: 8),
            Text('Destination address: ${order.destinationAddress}',),
            const SizedBox(height: 8),
            Text('Description: ${order.description}'),
            const SizedBox(height: 8),
            Text('Order status: ${order.status.displayName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(order.status.name),
                )),
            const Divider(height: 32),
            const Text('Order Location:', style: TextStyle(fontWeight: FontWeight.bold)),

            if (_isLoadingOrderLocation)
              const Center(child: CircularProgressIndicator())
            else if (_orderLocationError != null)
              Text('Error loading order location: $_orderLocationError', style: const TextStyle(color: Colors.red))
            else if (_orderLocation != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latitude: ${_orderLocation!.latitude}\nLongitude: ${_orderLocation!.longitude}'),
                    const SizedBox(height: 16),
                    Container(
                      height: 300, // Define a fixed height for the map
                      child: FlutterMap(
                        mapController: _mapController, // Assign the controller
                        options: MapOptions(
                          center: _initialMapCenter, // Initial center
                          zoom: _initialMapZoom, // Initial zoom
                          // Disable gestures that conflict with ListView scrolling if needed
                          // interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                        ),
                        children: [
                          TileLayer(
                            // Standard OpenStreetMap tile server URL
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.yourcompany.yourappname', // Replace with your package name
                            // Subdomains can be added if needed for different tile servers
                            // subdomains: ['a', 'b', 'c'],
                          ),
                          // Add other layers like polyline, polygons etc. here
                          MarkerLayer(
                            markers: _markers, // Pass the list of markers
                          ),
                          if (_polylines.isNotEmpty) PolylineLayer(polylines: _polylines),
                        ],
                      ),
                    ),
                  ],
                )
              else
                const Text('Location data not available for this order.'),


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

  @override
  void dispose() {
    _mapController.dispose(); // Dispose the map controller
    _trackingTimer?.cancel();
    _orderLocationPollingTimer?.cancel();
    super.dispose();
  }
}