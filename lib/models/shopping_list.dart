import 'shopping_list_item.dart';

class ShoppingList {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final List<ShoppingListItem> items;

  ShoppingList({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    this.items = const [],
  });

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ShoppingListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
