import '../models/supermarket.dart';
import 'distance_calculator.dart';

/// Algoritmo greedy "nearest neighbor" per ottimizzare un piccolo giro
/// spesa (2-3 supermercati) a partire dalla posizione dell'utente.
class RouteOptimizer {
  static List<Supermarket> optimizeRoute({
    required double startLat,
    required double startLon,
    required List<Supermarket> supermarkets,
  }) {
    if (supermarkets.isEmpty) return [];

    final remaining = List<Supermarket>.from(supermarkets);
    final route = <Supermarket>[];

    double currentLat = startLat;
    double currentLon = startLon;

    while (remaining.isNotEmpty) {
      remaining.sort((a, b) {
        final distA = DistanceCalculator.haversineDistance(
          lat1: currentLat,
          lon1: currentLon,
          lat2: a.latitude,
          lon2: a.longitude,
        );
        final distB = DistanceCalculator.haversineDistance(
          lat1: currentLat,
          lon1: currentLon,
          lat2: b.latitude,
          lon2: b.longitude,
        );
        return distA.compareTo(distB);
      });

      final next = remaining.removeAt(0);
      route.add(next);
      currentLat = next.latitude;
      currentLon = next.longitude;
    }

    return route;
  }

  static double totalRouteDistance({
    required double startLat,
    required double startLon,
    required List<Supermarket> route,
  }) {
    if (route.isEmpty) return 0.0;

    double total = 0.0;
    double currentLat = startLat;
    double currentLon = startLon;

    for (final stop in route) {
      total += DistanceCalculator.haversineDistance(
        lat1: currentLat,
        lon1: currentLon,
        lat2: stop.latitude,
        lon2: stop.longitude,
      );
      currentLat = stop.latitude;
      currentLon = stop.longitude;
    }

    return total;
  }
}
