import 'package:flutter/material.dart';
import '../widgets/liquid_tab_bar.dart';

/// Example screen demonstrating the LiquidTabBar widget
///
/// This shows how to use the new liquid/glass effect tab bar
/// that matches the style of the liquid navbar.
class LiquidTabBarExample extends StatefulWidget {
  const LiquidTabBarExample({super.key});

  @override
  State<LiquidTabBarExample> createState() => _LiquidTabBarExampleState();
}

class _LiquidTabBarExampleState extends State<LiquidTabBarExample> {
  int _currentIndex = 0;

  final List<LiquidTabBarItem> _tabs = const [
    LiquidTabBarItem(label: 'Home', icon: Icons.home_rounded),
    LiquidTabBarItem(label: 'Search', icon: Icons.search_rounded),
    LiquidTabBarItem(
      label: 'Favorites',
      icon: Icons.favorite_rounded,
      badge: '5', // Optional badge
    ),
    LiquidTabBarItem(label: 'Profile', icon: Icons.person_rounded),
  ];

  final List<Widget> _pages = const [
    _TabPage(color: Colors.blue, title: 'Home Page'),
    _TabPage(color: Colors.green, title: 'Search Page'),
    _TabPage(color: Colors.red, title: 'Favorites Page'),
    _TabPage(color: Colors.purple, title: 'Profile Page'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F3),
      appBar: AppBar(
        title: const Text('Liquid Tab Bar Example'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: LiquidTabBar(
        items: _tabs,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedColor: const Color(0xFF2563EB),
        unselectedColor: const Color.fromARGB(255, 100, 100, 100),
        backgroundColor: Colors.white,
        height: 70,
        indicatorHeight: 3,
      ),
    );
  }
}

/// Simple colored page for demonstration
class _TabPage extends StatelessWidget {
  final Color color;
  final String title;

  const _TabPage({required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_rounded, size: 80, color: color),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Swipe or tap tabs to navigate',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
