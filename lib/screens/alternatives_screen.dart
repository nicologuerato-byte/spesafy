import 'package:flutter/material.dart';
import '../config/theme.dart';

class AlternativesScreen extends StatelessWidget {
  const AlternativesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alternative')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.swap_horiz, size: 64, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text('Alternative in arrivo', style: AppTypography.titleMedium),
            SizedBox(height: 8),
            Text(
              'Qui troverai prodotti alternativi più convenienti',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
