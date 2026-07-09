import 'dart:math';

/// Calcola distanze in km tra coordinate geografiche usando la formula
/// dell'emisenoverso (Haversine). Nessuna dipendenza esterna.
class DistanceCalculator {
  static const double _earthRadiusKm = 6371.0;

  static double haversineDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) => degrees * pi / 180.0;
}
