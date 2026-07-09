class Supermarket {
  final String id;
  final String name;
  final String chain;
  final double latitude;
  final double longitude;
  final String address;

  Supermarket({
    required this.id,
    required this.name,
    required this.chain,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory Supermarket.fromJson(Map<String, dynamic> json) {
    return Supermarket(
      id: json['id'] as String,
      name: json['name'] as String,
      chain: json['chain'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'chain': chain,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}
