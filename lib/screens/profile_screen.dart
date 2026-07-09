import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isProcessing = false;

  Future<void> _signOut() async {
    setState(() => _isProcessing = true);
    try {
      await ref.read(signOutProvider.future);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Errore durante il logout.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina account'),
        content: const Text(
          'Sei sicuro di voler eliminare il tuo account? '
          'Questa azione non può essere annullata.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);
    try {
      final client = Supabase.instance.client;
      await client.rpc('delete_user_account');
      await client.auth.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossibile eliminare l\'account. Riprova più tardi.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profilo')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 32,
                child: Icon(Icons.person, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                user?.email ?? 'Utente',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _isProcessing ? null : _signOut,
                  icon: const Icon(Icons.logout),
                  label: const Text('Esci'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _isProcessing ? null : _deleteAccount,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(color: Theme.of(context).colorScheme.error),
                  ),
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Elimina account'),
                ),
              ),
              if (_isProcessing) ...[
                const SizedBox(height: 24),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
