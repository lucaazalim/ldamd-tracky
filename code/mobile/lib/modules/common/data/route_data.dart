import 'package:latlong2/latlong.dart';

/// A model representing a route in the system.
///
/// This class includes details such as distance, duration, start and end addresses, and polyline points for the route.
class AppRoute {
  final String? distance;
  final String? duration;
  final String? startAddress;
  final String? endAddress;
  AppRoute({this.distance, this.duration, this.startAddress, this.endAddress, required List<LatLng> polylinePoints/*, this.polylinePoints*/});
}

class AppRouteSummary {
  final String? mapUrl;
  final List<AppRoute>? routes;

  AppRouteSummary({this.mapUrl, this.routes});

}
