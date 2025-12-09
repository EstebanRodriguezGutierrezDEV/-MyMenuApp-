import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'features/shopping/providers/shopping_list_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://bbqahmiuxvlfagcmhxpm.supabase.co',
    anonKey: 'sb_publishable_itNwY8ZlDV-5BqnBmHxEPw_JX4Y5GOq',
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
