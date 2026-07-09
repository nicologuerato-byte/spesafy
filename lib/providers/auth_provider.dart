import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient get _supabase => Supabase.instance.client;

/// Emette lo stato di autenticazione corrente ad ogni cambiamento
/// (login, logout, refresh token, ecc.).
final authProvider = StreamProvider<AuthState>((ref) {
  return _supabase.auth.onAuthStateChange;
});

final signInProvider = FutureProvider.family<void, ({String email, String password})>(
  (ref, params) async {
    await _supabase.auth.signInWithPassword(
      email: params.email,
      password: params.password,
    );
  },
);

final signUpProvider = FutureProvider.family<void, ({String email, String password})>(
  (ref, params) async {
    await _supabase.auth.signUp(
      email: params.email,
      password: params.password,
    );
  },
);

final signOutProvider = FutureProvider<void>((ref) async {
  await _supabase.auth.signOut();
});
