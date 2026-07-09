import 'package:flutter/material.dart';
import 'shopping_list_screen.dart';
import 'wishlist_screen.dart';
import 'auth_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spesafy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, size: 80, color: Colors.green),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingListScreen()),
              ),
              child: const Text('Shopping List'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
              ),
              child: const Text('Wishlist'),
            ),
          ],
        ),
      ),
    );
  }
}
