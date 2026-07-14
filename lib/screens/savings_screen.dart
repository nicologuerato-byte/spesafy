import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme.dart';
import '../models/scan_model.dart';
import '../providers/scan_provider.dart';

class SavingsScreen extends ConsumerWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scansAsyncValue = ref.watch(allScansProvider);
    final scanService = ref.watch(scanServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Soldi'),
        actions: [
          // Pulsante Sync
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await scanService.syncScans();
              await ref.refresh(allScansProvider.future);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Sincronizzazione completata')),
                );
              }
            },
          ),
        ],
      ),
      body: scansAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Errore: $err')),
        data: (scans) {
          final totalSaved = scans.fold<double>(
            0,
            (sum, scan) => sum + (scan.price ?? 0),
          );
          final avgSaved =
              scans.isEmpty ? 0.0 : totalSaved / scans.length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _TotalSavingsCard(total: totalSaved),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.qr_code_scanner,
                      label: 'Scansioni',
                      value: '${scans.length}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.trending_up,
                      label: 'Risparmio medio',
                      value: '€${avgSaved.toStringAsFixed(2)}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Scansioni recenti',
                  style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              if (scans.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Nessuno scan ancora. Inizia a scansionare!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...scans.map((scan) => _RecentScanTile(scan: scan)),
            ],
          );
        },
      ),
    );
  }
}

class _TotalSavingsCard extends StatelessWidget {
  final double total;

  const _TotalSavingsCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Risparmio totale',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '€${total.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'da tutti gli scan',
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
  final ScanModel scan;

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
                Text(
                  scan.productName ?? 'Prodotto ${scan.barcode}',
                  style: AppTypography.bodyLarge,
                ),
                Text(
                  scan.supermarket ?? 'Non specificato',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Text(
            '+€${(scan.price ?? 0).toStringAsFixed(2)}',
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
