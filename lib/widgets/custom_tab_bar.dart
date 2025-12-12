import 'package:flutter/material.dart';

class CustomTabBarItem {
  final String label;
  final IconData icon;
  final String? badge;

  const CustomTabBarItem({required this.label, required this.icon, this.badge});
}

class CustomTabBar extends StatelessWidget {
  final List<CustomTabBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomTabBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Icon(
                              item.icon,
                              size: 24,
                              color: isSelected
                                  ? const Color(0xFF2563EB) // Primary Blue
                                  : Colors.grey[600],
                            ),
                            if (item.badge != null)
                              Positioned(
                                right: -8,
                                top: -8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981), // Accent Green
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    item.badge!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF2563EB) // Primary Blue
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// Material icons for tab bar
class TabBarIcons {
  static const IconData home = Icons.home;
  static const IconData person = Icons.person;
  static const IconData settings = Icons.settings;
  static const IconData cart = Icons.shopping_cart;
  static const IconData heart = Icons.favorite;
  static const IconData search = Icons.search;
  static const IconData bell = Icons.notifications;
  static const IconData star = Icons.star;
  static const IconData bookmark = Icons.bookmark;
}
