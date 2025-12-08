import 'package:flutter/material.dart';
import 'widgets/custom_nav_bar.dart';
import 'widgets/hero_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: -20,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HeroContent(
            animation: _animation,
            homeKey: _homeKey,
            aboutKey: _aboutKey,
            howItWorksKey: _howItWorksKey,
          ),
          CustomNavBar(
            onMenuTap: () => _scrollToSection(_homeKey),
            onAboutTap: () => _scrollToSection(_aboutKey),
            onHowItWorksTap: () => _scrollToSection(_howItWorksKey),
          ),
        ],
      ),
    );
  }
}
