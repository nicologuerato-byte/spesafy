import 'package:supabase_flutter/supabase_flutter.dart';

class ScanService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Salva uno scan nella tabella 'scans'
  Future<void> saveScan({
    required String barcode,
    required String productName,
    required String supermarket,
    required double price,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Utente non autenticato');
      }

      await _supabase.from('scans').insert({
        'user_id': userId,
        'barcode': barcode,
        'product_name': productName,
        'supermarket': supermarket,
        'price': price,
      });
    } catch (e) {
      throw Exception('Errore nel salvataggio dello scan: $e');
    }
  }

  /// Recupera tutti gli scans dell'utente
  Future<List<Map<String, dynamic>>> getUserScans() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Utente non autenticato');
      }

      final response = await _supabase
          .from('scans')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Errore nel recupero degli scans: $e');
    }
  }

  /// Calcola il totale dei risparmi per l'utente
  Future<double> getTotalSavings() async {
    try {
      final scans = await getUserScans();
      double total = 0;
      for (var scan in scans) {
        final price = scan['price'];
        if (price != null) {
          total += (price as num).toDouble();
        }
      }
      return total;
    } catch (e) {
      throw Exception('Errore nel calcolo dei risparmi: $e');
    }
  }
}
