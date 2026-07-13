import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/scan_provider.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  late MobileScannerController controller;
  bool _isScanningPaused = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      formats: [BarcodeFormat.ean13, BarcodeFormat.ean8, BarcodeFormat.code128],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleBarcodeDetect(BarcodeCapture capture) {
    if (_isScanningPaused) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final Barcode barcode = barcodes.first;
    final String? rawValue = barcode.rawValue;

    if (rawValue != null && rawValue.isNotEmpty) {
      setState(() => _isScanningPaused = true);
      _showBarcodeDialog(rawValue);
    }
  }

  void _showBarcodeDialog(String barcode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Barcode rilevato'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Codice: $barcode'),
            const SizedBox(height: 16),
            const Text('Inserisci i dettagli del prodotto'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isScanningPaused = false);
            },
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleScannedProduct(barcode);
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }

  void _handleScannedProduct(String barcode) async {
    try {
      final scanService = ref.read(scanServiceProvider);
      
      await scanService.saveScan(
        barcode: barcode,
        productName: 'Prodotto ($barcode)',
        supermarket: 'Esselunga',
        price: 2.50,
      );

      setState(() => _isScanningPaused = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scan salvato: $barcode'),
            backgroundColor: Colors.green,
          ),
        );
      }

      ref.invalidate(userScansProvider);
    } catch (e) {
      setState(() => _isScanningPaused = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scansiona'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _handleBarcodeDetect,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(80),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_2, color: Colors.green, size: 40),
                  SizedBox(height: 16),
                  Text(
                    'Inquadra il codice a barre',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
