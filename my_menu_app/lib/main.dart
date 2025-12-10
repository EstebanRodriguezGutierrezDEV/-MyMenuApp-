import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'features/shopping/providers/shopping_list_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/layout/main_layout_screen.dart'; // Import MainLayout

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? initializationError;
  bool isLoggedIn = false;

  try {
    await dotenv.load(fileName: ".env");

    // Initialize Supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );

    // Check Auto-Login
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;
    final session = Supabase.instance.client.auth.currentSession;

    if (rememberMe && session != null) {
      isLoggedIn = true;
    }
  } catch (e) {
    debugPrint('Failed to initialize app: $e');
    initializationError = e.toString();
  }

  runApp(
    MainApp(initializationError: initializationError, isLoggedIn: isLoggedIn),
  );
}

class MainApp extends StatelessWidget {
  final String? initializationError;
  final bool isLoggedIn;

  const MainApp({
    super.key,
    this.initializationError,
    required this.isLoggedIn,
  });

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
        home: isLoggedIn ? const MainLayoutScreen() : const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading or just wait a bit to show logo
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ), // Navigate to Welcome Screen
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/splash_logo.png',
          width: 1000, // Increased size
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
