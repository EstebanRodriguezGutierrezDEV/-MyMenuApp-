import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'features/shopping/providers/shopping_list_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
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
