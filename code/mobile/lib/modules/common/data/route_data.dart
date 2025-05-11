
import 'package:latlong2/latlong.dart';

class AppRoute {
  final String? distance;
  final String? duration;
  final String? startAddress;
  final String? endAddress;
  // final List<LatLng>? polylinePoints; // Necessita importar LatLng de latlong2
  AppRoute({this.distance, this.duration, this.startAddress, this.endAddress, required List<LatLng> polylinePoints/*, this.polylinePoints*/});
}

// Estrutura mock para representar o resumo das rotas
class AppRouteSummary {
  final String? mapUrl; // URL para abrir em um mapa externo
  final List<AppRoute>? routes; // Pode haver múltiplas opções de rota

  AppRouteSummary({this.mapUrl, this.routes});

}
