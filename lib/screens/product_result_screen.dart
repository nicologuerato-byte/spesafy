import 'package:flutter/material.dart';

class ProductResultScreen extends StatelessWidget {
  const ProductResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: const Center(child: Text('Products')),
    );
  }
}
