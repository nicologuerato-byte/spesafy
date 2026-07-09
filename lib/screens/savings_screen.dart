import 'package:flutter/material.dart';
import '../config/theme.dart';

class _ScanEntry {
  final String product;
  final String store;
  final double saved;

  const _ScanEntry({
    required this.product,
    required this.store,
    required this.saved,
  });
}

const List<_ScanEntry> _mockRecentScans = [
  _ScanEntry(product: 'Pasta Barilla 500g', store: 'Esselunga', saved: 0.35),
  _ScanEntry(product: 'Latte Parmalat 1L', store: 'Carrefour', saved: 0.20),
  _ScanEntry(product: 'Olio EVO Monini 1L', store: 'Conad', saved: 1.80),
  _ScanEntry(product: 'Caffè Lavazza 250g', store: 'Esselunga', saved: 0.90),
  _ScanEntry(product: 'Detersivo Dash 1.5L', store: 'Lidl', saved: 1.10),
];

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soldi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _TotalSavingsCard(),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.qr_code_scanner,
                  label: 'Scansioni',
                  value: '18',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.trending_up,
                  label: 'Risparmio medio',
                  value: '€0.69',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Scansioni recenti', style: AppTypography.titleMedium),
          const SizedBox(height: 12),
          ..._mockRecentScans.map((scan) => _RecentScanTile(scan: scan)),
        ],
      ),
    );
  }
}

class _TotalSavingsCard extends StatelessWidget {
  const _TotalSavingsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risparmio totale',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            '€12.47',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'questo mese',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 12),
          Text(value, style: AppTypography.titleLarge),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}

class _RecentScanTile extends StatelessWidget {
  final _ScanEntry scan;

  const _RecentScanTile({required this.scan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                color: AppColors.primaryDark, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scan.product, style: AppTypography.bodyLarge),
                Text(scan.store, style: AppTypography.caption),
              ],
            ),
          ),
          Text(
            '+€${scan.saved.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
