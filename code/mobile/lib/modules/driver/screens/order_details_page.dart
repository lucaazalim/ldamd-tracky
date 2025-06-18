import 'package:flutter/material.dart';
import 'package:mobile/modules/common/data/enum/order_status.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:mobile/modules/common/data/route_data.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:mobile/modules/common/services/location_service.dart';
import 'package:mobile/modules/common/services/tracking_service.dart';
import 'package:mobile/modules/common/data/tracking.dart';
import 'package:mobile/modules/common/services/orders_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../common/components/theme_provider.dart';

/// A page that displays detailed information about a specific order for drivers.
///
/// This page includes a map showing the driver's location, the order's location, and the route between them.
/// It fetches and displays data asynchronously, including route details and order information.
class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final LocationService _userLocationService = LocationService();
  final TrackingService _orderLocationService = TrackingService();
  final OrdersService _ordersService = OrdersService();

  Order? _order;
  bool _isLoadingOrder = true;
  String? _orderError;

  Position? _driverPosition;
  String? _locationError;

  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];

  AppRouteSummary? _routeSummary;
  bool _isLoadingRoute = true;
  String? _routeError;

  String? _driverID;

  Timer? _trackingTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchOrderAndInitRoute());
  }

  @override
  void dispose() {
    _trackingTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _startTracking() {
    _trackingTimer?.cancel();
    _trackingTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (_order == null || _driverPosition == null) return;
      if (_order!.status != OrderStatus.onCourse) {
        timer.cancel();
        return;
      }
      try {
        final pos = await _userLocationService.getCurrentLocation();
        setState(() {
          _driverPosition = pos;
        });
        await _orderLocationService.sendTracking(
          orderId: _order!.id,
          latitude: pos.latitude,
          longitude: pos.longitude,
        );
      } catch (e) {
        // ignore errors for now
      }
    });
  }

  void _stopTracking() {
    _trackingTimer?.cancel();
  }

  Future<void> _fetchOrderAndInitRoute() async {

    final prefs = await SharedPreferences.getInstance();
    _driverID = prefs.getString('userId') ?? "";

    final orderId = ModalRoute.of(context)?.settings.arguments as String?;
    if (orderId == null) {
      setState(() {
        _orderError = 'Order ID not provided.';
        _isLoadingOrder = false;
        _isLoadingRoute = false;
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
        await _initRouteFlow(_order!);
        if (_order!.status == OrderStatus.onCourse) {
          _startTracking();
        } else {
          _stopTracking();
        }
      }
    } catch (e) {
      setState(() {
        _orderError = 'Error loading order.';
        _isLoadingOrder = false;
        _isLoadingRoute = false;
      });
    }
  }

  Future<void> _initRouteFlow(Order order) async {
    try {
      final pos = await _userLocationService.getCurrentLocation();
      setState(() {
        _driverPosition = pos;
        _markers = [
          Marker(
            point: LatLng(pos.latitude, pos.longitude),
            width: 80,
            height: 80,
            child: const Icon(Icons.navigation, color: Colors.red, size: 40),
          ),
        ];
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(LatLng(pos.latitude, pos.longitude), 15.0);
        }
      });
    } catch (e) {
      setState(() {
        _locationError = e.toString();
        _isLoadingRoute = false;
        _routeError = 'Could not get your location.';
      });
      return;
    }

    Tracking? orderLoc;
    try {
      orderLoc = await _orderLocationService.getLatestLocationForOrder(order.id);
      if (orderLoc == null) throw Exception('No location found for order.');
    } catch (e) {
      setState(() {
        _routeError = 'Could not get the order location.';
        _isLoadingRoute = false;
      });
      return;
    }

    await _fetchRouteBetween(
      driverPos: _driverPosition!,
      destination: LatLng(orderLoc.latitude, orderLoc.longitude),
    );
  }

  Future<void> _fetchRouteBetween({
    required Position driverPos,
    required LatLng destination,
  }) async {
    setState(() {
      _isLoadingRoute = true;
      _routeError = null;
      _routeSummary = null;
      _polylines = [];
    });

    try {
      final client = OpenRouteService(apiKey: '5b3ce3597851110001cf6248fe6e4e794c9247b599ab35ed87100e77');
      final List<ORSCoordinate> routeCoordinates = await client.directionsRouteCoordsGet(
        startCoordinate: ORSCoordinate(latitude: driverPos.latitude, longitude: driverPos.longitude),
        endCoordinate: ORSCoordinate(latitude: destination.latitude, longitude: destination.longitude),
        profileOverride: ORSProfile.drivingCar,
      );
      final routePoints = routeCoordinates
          .map((coord) => LatLng(coord.latitude, coord.longitude))
          .toList();

      // Apenas exibe distância e duração como "-" (não disponíveis)
      final route = AppRoute(
        distance: '-',
        duration: '-',
        startAddress: null,
        endAddress: null,
        polylinePoints: routePoints,
      );

      setState(() {
        _routeSummary = AppRouteSummary(
          mapUrl:
          'https://maps.google.com/maps?saddr=${driverPos.latitude},${driverPos.longitude}&daddr=${destination.latitude},${destination.longitude}',
          routes: [route],
        );
        _polylines = [Polyline(points: routePoints, strokeWidth: 4.0, color: Colors.blue)];
        _markers.add(
          Marker(
            point: destination,
            width: 60,
            height: 60,
            child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
          ),
        );
        _isLoadingRoute = false;
      });
    } catch (e) {
      setState(() {
        _routeError = 'Erro ao buscar rota: $e';
        _isLoadingRoute = false;
      });
    }
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
        body: Center(child: Text(_orderError!)),
      );
    }
    if (_order == null) {
      return const Scaffold(
        body: Center(child: Text('Order not found.')),
      );
    }
    final order = _order!;
    bool isConfirmed = order.status == OrderStatus.pending;
    final initialCenter = _driverPosition != null
        ? LatLng(_driverPosition!.latitude, _driverPosition!.longitude)
        : const LatLng(-19.9208, -43.9378);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 5, 242, 112), // seta verde
        ),
        title: const Text('Order Details'),
        titleTextStyle: TextStyle(color: Color.fromARGB(255, 5, 242, 112), fontSize: 20.0),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.brightness_2 : Icons.wb_sunny),
            onPressed: themeProvider.toggleTheme,
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
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Order: ${order.id.substring(0, 5)}', style: const TextStyle(fontSize: 18)),
            Text('Origin address: ${order.originAddress}'),
            Text('Destination address: ${order.destinationAddress}'),
            Text('Order description: ${order.description}'),
            Text('Order status: ${order.status.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(order.status.name),
                )),
            const Divider(height: 32),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                isConfirmed
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 5, 242, 112),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            minimumSize: const Size.fromHeight(46),
                          ),
                          icon: const Icon(Icons.check_circle, color: Colors.black),
                          label: const Text(
                            'Accept order',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          onPressed: () {
                            OrdersService().acceptOrder(order.id, _driverID!);
                          },
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 5, 242, 112),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            minimumSize: const Size.fromHeight(46),
                          ),
                          icon: const Icon(Icons.edit, color: Colors.black),
                          label: const Text(
                            'Change order status',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/driver/order/update-status',
                              arguments: order,
                            );
                          },
                        ),
                      ),
              ],
            ),
            const Divider(height: 32),
            const Text('Location and Route:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 300,
              child: _isLoadingRoute
                  ? const Center(child: CircularProgressIndicator())
                  : _driverPosition == null && _locationError == null
                      ? const Center(child: CircularProgressIndicator())
                      : _locationError != null
                          ? Center(
                              child: Text(
                                'Error getting driver location: [38;5;9m$_locationError[0m',
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                          : FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(center: initialCenter, zoom: 15.0),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.yourcompany.yourappname',
                                ),
                                MarkerLayer(markers: _markers),
                                if (_polylines.isNotEmpty) PolylineLayer(polylines: _polylines),
                              ],
                            ),
            ),
          ],
        ),
      ),
    );
  }
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