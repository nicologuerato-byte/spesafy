class ShoppingListItem {
  final String id;
  final String shoppingListId;
  final String productId;
  final int quantity;
  final String productName;

  ShoppingListItem({
    required this.id,
    required this.shoppingListId,
    required this.productId,
    required this.quantity,
    required this.productName,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json['id'] as String,
      shoppingListId: json['shopping_list_id'] as String,
      productId: json['product_id'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      productName: json['product_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopping_list_id': shoppingListId,
      'product_id': productId,
      'quantity': quantity,
      'product_name': productName,
    };
  }

  ShoppingListItem copyWith({int? quantity}) {
    return ShoppingListItem(
      id: id,
      shoppingListId: shoppingListId,
      productId: productId,
      quantity: quantity ?? this.quantity,
      productName: productName,
    );
  }
}
