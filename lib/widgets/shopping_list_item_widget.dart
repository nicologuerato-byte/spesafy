import 'package:flutter/material.dart';

import '../models/shopping_list_item.dart';

class ShoppingListItemWidget extends StatelessWidget {
  final ShoppingListItem item;
  final double? price;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback onDelete;

  const ShoppingListItemWidget({
    super.key,
    required this.item,
    required this.onDelete,
    this.price,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.productName,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: item.quantity > 1
                ? () => onQuantityChanged?.call(item.quantity - 1)
                : null,
          ),
          SizedBox(
            width: 24,
            child: Text('${item.quantity}', textAlign: TextAlign.center),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => onQuantityChanged?.call(item.quantity + 1),
          ),
          if (price != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '€${(price! * item.quantity).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
