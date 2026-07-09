import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product.dart';
import '../models/price_result.dart';
import '../models/shopping_list.dart';
import '../models/supermarket.dart';

/// Wrapper su tutte le query Supabase usate dall'app. Ogni metodo
/// intercetta gli errori e ritorna un valore "vuoto" (null / lista vuota /
/// false) invece di propagare l'eccezione, così la UI può mostrare uno
/// stato di errore gestito senza crashare.
class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Product?> getOrCreateProduct({
    required String ean,
    required String name,
    String? category,
    String? imageUrl,
  }) async {
    try {
      final existing = await _client
          .from('products')
          .select()
          .eq('ean', ean)
          .maybeSingle();

      if (existing != null) {
        return Product.fromJson(existing);
      }

      final inserted = await _client
          .from('products')
          .insert({
            'ean': ean,
            'name': name,
            'category': category,
            'image_url': imageUrl,
          })
          .select()
          .single();

      return Product.fromJson(inserted);
    } catch (e) {
      return null;
    }
  }

  Future<List<PriceResult>> getPricesForProduct(String productId) async {
    try {
      final response = await _client
          .from('prices')
          .select('*, product:products(*), supermarket:supermarkets(*)')
          .eq('product_id', productId);

      final data = response as List<dynamic>;

      return data.map((row) {
        final map = row as Map<String, dynamic>;
        return PriceResult(
          product: Product.fromJson(map['product'] as Map<String, dynamic>),
          supermarket:
              Supermarket.fromJson(map['supermarket'] as Map<String, dynamic>),
          price: (map['price'] as num).toDouble(),
          distanceKm: 0.0,
          lastUpdated: DateTime.parse(map['last_updated'] as String),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<ShoppingList>> getShoppingLists(String userId) async {
    try {
      final response = await _client
          .from('shopping_lists')
          .select('*, items:shopping_list_items(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data
          .map((row) => ShoppingList.fromJson(row as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<ShoppingList?> createShoppingList({
    required String userId,
    required String name,
  }) async {
    try {
      final inserted = await _client
          .from('shopping_lists')
          .insert({
            'user_id': userId,
            'name': name,
          })
          .select()
          .single();

      return ShoppingList.fromJson(inserted);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addToShoppingList({
    required String shoppingListId,
    required String productId,
    required String productName,
    int quantity = 1,
  }) async {
    try {
      await _client.from('shopping_list_items').insert({
        'shopping_list_id': shoppingListId,
        'product_id': productId,
        'product_name': productName,
        'quantity': quantity,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromShoppingList(String itemId) async {
    try {
      await _client.from('shopping_list_items').delete().eq('id', itemId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateShoppingListItemQuantity({
    required String itemId,
    required int quantity,
  }) async {
    try {
      await _client
          .from('shopping_list_items')
          .update({'quantity': quantity})
          .eq('id', itemId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addToWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      await _client.from('wishlist').insert({
        'user_id': userId,
        'product_id': productId,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Product>> getWishlist(String userId) async {
    try {
      final response = await _client
          .from('wishlist')
          .select('product:products(*)')
          .eq('user_id', userId);

      final data = response as List<dynamic>;
      return data
          .map((row) => Product.fromJson(
              (row as Map<String, dynamic>)['product'] as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> removeFromWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      await _client
          .from('wishlist')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
