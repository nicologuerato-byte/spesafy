import 'package:flutter/material.dart';
import '../config/theme.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sintesi')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text('Statistiche in arrivo', style: AppTypography.titleMedium),
            SizedBox(height: 8),
            Text(
              'Qui vedrai l\'andamento dei tuoi risparmi nel tempo',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
