import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/scan_model.dart';
import 'screens/root_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env
  await dotenv.load(fileName: '.env');
  
  // Hive init
  await Hive.initFlutter();
  Hive.registerAdapter(ScanModelAdapter());
  
  // Init Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  // Init Anonymous Auth
  await _initAnonymousAuth();
  
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _initAnonymousAuth() async {
  final supabase = Supabase.instance.client;
  try {
    final session = supabase.auth.currentSession;
    if (session == null) {
      await supabase.auth.signInAnonymously();
    }
    print('✅ Auth anonima OK');
  } catch (e) {
    print('⚠️ Auth anonima non disponibile (offline): $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spesafy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RootScreen(),
    );
  }
}
