import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'features/shopping/providers/shopping_list_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? initializationError;
  try {
    await dotenv.load(fileName: ".env");

    // Initialize Supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
  } catch (e) {
    debugPrint('Failed to initialize app: $e');
    initializationError = e.toString();
  }

  runApp(MainApp(initializationError: initializationError));
}

class MainApp extends StatelessWidget {
  final String? initializationError;
  const MainApp({super.key, this.initializationError});

  @override
  Widget build(BuildContext context) {
    if (initializationError != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'Error de Inicialización',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    initializationError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Por favor, revisa tu archivo .env',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return ChangeNotifierProvider(
      create: (context) => ShoppingListProvider(),
      child: MaterialApp(
        title: 'MyMenu',
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF9F9F5)),
        home: const HomeScreen(),
      ),
    );
  }
}
