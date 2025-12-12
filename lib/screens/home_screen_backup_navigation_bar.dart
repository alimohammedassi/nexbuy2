// BACKUP: Old Glassmorphic Navigation Bar Implementation
// This file contains the backup of the old navigation bar code
// To restore: Copy the _buildGlassmorphicTabBar and _buildGlassTabItem methods
// back to home_screen.dart and replace the new navigation bar implementation

import 'dart:ui';
import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class BackupGlassmorphicTabBar {
  // Backup of _buildGlassmorphicTabBar method
  Widget buildGlassmorphicTabBar(
    BuildContext context,
    int tabIndex,
    Function(int) onTabChanged,
    AnimationController? animationController,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildGlassTabItem(
                  context: context,
                  icon: Icons.home_rounded,
                  label: AppLocalizations.of(context).home,
                  index: 0,
                  isSelected: tabIndex == 0,
                  onTap: () => onTabChanged(0),
                  animationController: animationController,
                ),
                _buildGlassTabItem(
                  context: context,
                  icon: Icons.smart_toy_rounded,
                  label: AppLocalizations.of(context).aiChat,
                  index: 1,
                  isSelected: tabIndex == 1,
                  onTap: () => onTabChanged(1),
                  animationController: animationController,
                ),
                _buildGlassTabItem(
                  context: context,
                  icon: Icons.person_rounded,
                  label: AppLocalizations.of(context).profile,
                  index: 2,
                  isSelected: tabIndex == 2,
                  onTap: () => onTabChanged(2),
                  animationController: animationController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Backup of _buildGlassTabItem method
  Widget _buildGlassTabItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
    AnimationController? animationController,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap();
          animationController?.forward(from: 0);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2563EB).withValues(alpha: 0.8),
                      const Color(0xFF1D4ED8).withValues(alpha: 0.9),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[700],
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
