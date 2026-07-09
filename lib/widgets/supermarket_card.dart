import 'package:flutter/material.dart';

import '../models/price_result.dart';

class SupermarketCard extends StatelessWidget {
  final PriceResult priceResult;
  final VoidCallback? onTap;

  const SupermarketCard({super.key, required this.priceResult, this.onTap});

  Color _priceColor(double price) {
    if (price < 0.80) return Colors.green;
    if (price <= 1.50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final supermarket = priceResult.supermarket;
    final color = _priceColor(priceResult.price);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supermarket.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      supermarket.chain,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.place,
                          size: 16,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text('${priceResult.distanceKm.toStringAsFixed(1)} km'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color),
                ),
                child: Text(
                  '€${priceResult.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
