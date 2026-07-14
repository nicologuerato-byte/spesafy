import 'package:flutter/material.dart';
import 'alternatives_screen.dart';
import 'scan_screen.dart';
import 'search_screen.dart';
import 'summary_screen.dart';
import 'savings_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const SavingsScreen(),
    const AlternativesScreen(),
    const ScanScreen(),
    const SummaryScreen(),
    const SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Soldi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Alternative',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scansiona',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.summarize),
            label: 'Sintesi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cerca',
          ),
        ],
      ),
    );
  }
}
