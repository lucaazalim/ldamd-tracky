import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart'; // Import flutter_map
import 'package:latlong2/latlong.dart'; // Import LatLng from latlong2
import 'package:mobile/modules/common/services/location_service.dart';
import 'package:mobile/modules/common/services/tracking_service.dart';
import 'package:mobile/modules/common/data/tracking.dart';
import '../../common/components/theme_provider.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:intl/intl.dart'; // Ensure intl is imported for date formatting if used in InfoWindow

/// A page that displays detailed information about a specific order.
///
/// This page includes a map showing the order's location and the user's current position.
/// It fetches and displays data asynchronously.
class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final LocationService _userLocationService = LocationService();
  final TrackingService _orderLocationService = TrackingService();

  Position? _userPosition;
  String? _userLocationError;

  Tracking? _orderLocation;
  bool _isLoadingOrderLocation = true;
  String? _orderLocationError;

  List<Marker> _markers = []; // Use a List for flutter_map markers
  final MapController _mapController = MapController(); // Controller for flutter_map

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrderLocation();
    });
  }

  Future<void> _fetchUserLocation() async {
    try {
      final pos = await _userLocationService.getCurrentLocation();
      setState(() {
        _userPosition = pos;
      });
    } catch (e) {
      setState(() {
        _userLocationError = e.toString();
      });
    }
  }

  Future<void> _fetchOrderLocation() async {
    final order = ModalRoute.of(context)?.settings.arguments as Order?;
    if (order == null) {
      setState(() {
        _orderLocationError = 'Order data not provided.';
        _isLoadingOrderLocation = false;
      });
      return;
    }

    try {
      final location = await _orderLocationService.getLatestLocationForOrder(order.id);

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
      }

    } catch (e) {
      setState(() {
        _orderLocationError = 'Error fetching order location: ${e.toString()}';
        _isLoadingOrderLocation = false;
      });
    }
  }

  void _addOrderMarker(Tracking location) {
    final marker = Marker(
      point: LatLng(location.latitude, location.longitude), // Use LatLng from latlong2
      width: 80, // Width of the marker widget
      height: 80, // Height of the marker widget
      child: Icon(
        Icons.location_pin, // Use a standard Flutter icon for the marker
        color: Colors.red, // Customize marker color
        size: 40,
      ),

    );

    setState(() {
      _markers = [marker]; // Replace existing markers with the new one
    });
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

    // Default initial camera position if order location is not yet loaded
    final LatLng _initialMapCenter = LatLng(_orderLocation?.latitude ?? -19.9208, _orderLocation?.longitude ?? -43.9378); // Defaulting to a known location if _orderLocation is null initially
    const double _initialMapZoom = 13.0;


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
            Text('Origin Address: ${order.originAddress}',),
            const SizedBox(height: 8),
            Text('Destination Address: ${order.destinationAddress}',),
            const SizedBox(height: 8),
            Text('Description: ${order.description}'),
            const SizedBox(height: 8),
            Text('Order Status: ${order.status.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(order.status.name),
                )),
            const Divider(height: 32),
            if (order.imageUrl != null && order.imageUrl!.isNotEmpty) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order image:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/delivery.jpg', // Caminho da imagem local
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ],
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
    super.dispose();
  }
}