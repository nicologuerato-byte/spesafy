class Product {
  final String id;
  final String ean;
  final String name;
  final String? category;
  final String? imageUrl;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.ean,
    required this.name,
    this.category,
    this.imageUrl,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      ean: json['ean'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ean': ean,
      'name': name,
      'category': category,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
