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

  Position? _driverPosition;
  String? _locationError;

  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];

  AppRouteSummary? _routeSummary;
  bool _isLoadingRoute = true;
  String? _routeError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initRouteFlow());
  }

  Future<void> _initRouteFlow() async {
    final order = ModalRoute.of(context)?.settings.arguments as Order?;
    if (order == null) {
      setState(() {
        _routeError = 'Order data not provided.';
        _isLoadingRoute = false;
      });
      return;
    }

    // 1. Get driver position
    try {
      final pos = await _userLocationService.getCurrentLocation();
      if (pos == null) throw Exception('Location service returned null position.');
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

    // 2. Get latest order location
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

    // 3. Fetch and draw route
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

      final route = AppRoute(
        distance: 'To do',
        duration: 'To do',
        startAddress: 'To do',
        endAddress: 'To do',
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
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Order) {
      return const Scaffold(
        body: Center(child: Text('Order data not provided.')),
      );
    }
    final order = args;

    bool isConfirmed = order.status == OrderStatus.pending;


    final initialCenter = _driverPosition != null
        ? LatLng(_driverPosition!.latitude, _driverPosition!.longitude)
        : const LatLng(-19.9208, -43.9378);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
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
            Text('Order ID: ${order.id}', style: const TextStyle(fontSize: 18)),
            Text('Client: ${order.costumer?.name ?? 'Unknown'}'),
            Text('Driver: ${order.driver?.name ?? 'Unknown'}'),
            Text('Address: ${order.originAddress}'),
            Text('Address: ${order.destinationAddress}'),
            Text('Description: ${order.description}'),
            Text('Status: ${order.status.name}'),
            const Divider(height: 32),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                isConfirmed
                    ? ElevatedButton(
                  onPressed: () {
                    print('Order accepted...');
                  },
                  child: const Text('Accept order'),
                )
                    : ElevatedButton(
                  onPressed: () {

                    Navigator.pushNamed(
                      context,
                      '/driver/order/update-status',
                      arguments: order,
                    );

                  },
                  child: const Text('Change order status'),
                ),
                const SizedBox(height: 15),
                const Text('Order image:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Image.asset(
                  'assets/images/delivery.jpg', // Caminho da imagem local
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const Divider(height: 32),
            const Text('Location and Route:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 300,
              child: _driverPosition == null && _locationError == null
                  ? const Center(child: CircularProgressIndicator())
                  : _locationError != null
                  ? Center(
                child: Text(
                  'Error getting driver location: $_locationError',
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
            const SizedBox(height: 16),
            const Text('Route Information:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_isLoadingRoute)
              const Center(child: CircularProgressIndicator())
            else if (_routeError != null)
              Center(
                child: Text(
                  'Error loading route: $_routeError',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (_routeSummary != null && _routeSummary!.routes?.isNotEmpty == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Origin: ${_routeSummary!.routes!.first.startAddress}'),
                    Text('Destination: ${_routeSummary!.routes!.first.endAddress}'),
                    Text('Distance: ${_routeSummary!.routes!.first.distance}'),
                    Text('Duration: ${_routeSummary!.routes!.first.duration}'),
                    if (_routeSummary!.mapUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: InkWell(
                          onTap: () {
                            // TODO: launch _routeSummary!.mapUrl com url_launcher
                          },
                          child: const Text(
                            'View on external map',
                            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                  ],
                )
              else
                const Text('Could not find a route for this order.'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
