import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/scan_model.dart';

class ScanService {
  final supabase = Supabase.instance.client;

  Box<ScanModel> get scansBox => Hive.box<ScanModel>('scans');

  /// Salva uno scan: prima tenta Supabase, poi fallback Hive
  Future<void> saveScan({
    required String barcode,
    required String? productName,
    required String? supermarket,
    required double? price,
  }) async {
    final scan = ScanModel(
      barcode: barcode,
      productName: productName,
      supermarket: supermarket,
      price: price,
      synced: false,
    );

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        await scansBox.add(scan);
        print('⚠️ Salvo localmente (non autenticato): $productName');
        return;
      }

      await supabase.from('scans').insert({
        'user_id': userId,
        'barcode': barcode,
        'product_name': productName,
        'supermarket': supermarket,
        'price': price,
      });
      print('✅ Scan sincronizzato: $productName ($barcode)');
    } catch (e) {
      await scansBox.add(scan);
      print('⚠️ Salvo offline: $productName (errore: $e)');
    }
  }

  /// Recupera scans
  Future<List<ScanModel>> getAllScans() async {
    return scansBox.values.toList().reversed.toList();
  }

  /// Sincronizza scans offline con Supabase
  Future<void> syncScans() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        print('❌ Non autenticato, sync non possibile');
        return;
      }

      final unsynced = scansBox.values.where((s) => !s.synced).toList();
      for (var scan in unsynced) {
        try {
          await supabase.from('scans').insert({
            'user_id': userId,
            'barcode': scan.barcode,
            'product_name': scan.productName,
            'supermarket': scan.supermarket,
            'price': scan.price,
          });
          scan.synced = true;
          await scan.save();
          print('✅ Sincronizzato: ${scan.productName}');
        } catch (e) {
          print('⚠️ Sync fallito per ${scan.barcode}: $e');
        }
      }
    } catch (e) {
      print('❌ Errore sync: $e');
    }
  }

  /// Calcola totale risparmi
  Future<double> getTotalSavings() async {
    double total = 0;
    for (var scan in scansBox.values) {
      if (scan.price != null) {
        total += scan.price!;
      }
    }
    return total;
  }
}
