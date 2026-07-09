import 'package:flutter/material.dart';
import '../config/theme.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Cerca un prodotto...',
            hintStyle: AppTypography.bodyMedium,
            border: InputBorder.none,
          ),
          style: AppTypography.bodyLarge,
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text('Ricerca in arrivo', style: AppTypography.titleMedium),
            SizedBox(height: 8),
            Text(
              'Cerca prodotti e confronta i prezzi tra i supermercati',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
