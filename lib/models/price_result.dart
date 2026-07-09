import 'product.dart';
import 'supermarket.dart';

class PriceResult {
  final Product product;
  final Supermarket supermarket;
  final double price;
  final double distanceKm;
  final DateTime lastUpdated;

  PriceResult({
    required this.product,
    required this.supermarket,
    required this.price,
    required this.distanceKm,
    required this.lastUpdated,
  });

  factory PriceResult.fromJson(Map<String, dynamic> json) {
    return PriceResult(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      supermarket:
          Supermarket.fromJson(json['supermarket'] as Map<String, dynamic>),
      price: (json['price'] as num).toDouble(),
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'supermarket': supermarket.toJson(),
      'price': price,
      'distance_km': distanceKm,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  /// Ritorna una nuova lista ordinata dal prezzo più basso al più alto.
  static List<PriceResult> sortByPrice(List<PriceResult> results) {
    final sorted = List<PriceResult>.from(results);
    sorted.sort((a, b) => a.price.compareTo(b.price));
    return sorted;
  }

  /// Ritorna solo i risultati entro il raggio (km) indicato.
  static List<PriceResult> filterByRadius(
    List<PriceResult> results,
    double radiusKm,
  ) {
    return results.where((r) => r.distanceKm <= radiusKm).toList();
  }
}
