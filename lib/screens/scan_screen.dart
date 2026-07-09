import 'package:flutter/material.dart';
import '../config/theme.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scansiona')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                size: 80,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            const Text('Scanner in arrivo', style: AppTypography.titleMedium),
            const SizedBox(height: 8),
            const Text(
              'Inquadra il codice a barre per confrontare i prezzi',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
