import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/scan_model.dart';

class ScanService {
  final supabase = Supabase.instance.client;
  late Box<ScanModel> scansBox;

  ScanService() {
    _initBox();
  }

  Future<void> _initBox() async {
    scansBox = await Hive.openBox<ScanModel>('scans');
  }

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
        // Salva offline
        await scansBox.add(scan);
        print('⚠️ Salvo localmente (non autenticato): $productName');
        return;
      }

      // Tenta Supabase
      await supabase.from('scans').insert({
        'user_id': userId,
        'barcode': barcode,
        'product_name': productName,
        'supermarket': supermarket,
        'price': price,
      });
      print('✅ Scan sincronizzato: $productName ($barcode)');
    } catch (e) {
      // Fallback: salva localmente
      await scansBox.add(scan);
      print('⚠️ Salvo offline: $productName (errore: $e)');
    }
  }

  /// Recupera scans: prima Hive (veloce), poi Supabase
  Future<List<ScanModel>> getAllScans() async {
    // Ritorna quelli locali per ora
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

  /// Cancella uno scan
  Future<void> deleteScan(int index) async {
    await scansBox.deleteAt(index);
  }

  /// Pulisci tutti i dati locali
  Future<void> clearAll() async {
    await scansBox.clear();
  }
}
