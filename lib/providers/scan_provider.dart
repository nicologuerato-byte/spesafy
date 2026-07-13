import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/scan_service.dart';

final scanServiceProvider = Provider((ref) {
  return ScanService();
});

final userScansProvider = FutureProvider((ref) async {
  final scanService = ref.watch(scanServiceProvider);
  return scanService.getUserScans();
});

final totalSavingsProvider = FutureProvider((ref) async {
  final scanService = ref.watch(scanServiceProvider);
  return scanService.getTotalSavings();
});
