import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidTabBarItem {
  final String label;
  final IconData icon;
  final String? badge;

  const LiquidTabBarItem({required this.label, required this.icon, this.badge});
}

class LiquidTabBar extends StatefulWidget {
  final List<LiquidTabBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final Color backgroundColor;
  final double height;
  final double indicatorHeight;

  const LiquidTabBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.selectedColor = const Color(0xFF2563EB),
    this.unselectedColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.height = 70,
    this.indicatorHeight = 3,
  });

  @override
  State<LiquidTabBar> createState() => _LiquidTabBarState();
}

class _LiquidTabBarState extends State<LiquidTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didUpdateWidget(LiquidTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: widget.selectedColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            child: Stack(
              children: [
                // Animated liquid indicator
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final itemWidth =
                        MediaQuery.of(context).size.width / widget.items.length;
                    final startPos = _previousIndex * itemWidth;
                    final endPos = widget.currentIndex * itemWidth;
                    final currentPos =
                        startPos + (endPos - startPos) * _animation.value;

                    return Positioned(
                      bottom: 0,
                      left: currentPos,
                      child: Container(
                        width: itemWidth,
                        height: widget.indicatorHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.selectedColor,
                              widget.selectedColor.withOpacity(0.6),
                            ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.selectedColor.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Tab items
                Row(
                  children: widget.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = widget.currentIndex == index;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onTap(index),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Icon with liquid animation
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOutCubic,
                                    padding: EdgeInsets.all(isSelected ? 8 : 0),
                                    decoration: isSelected
                                        ? BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                widget.selectedColor
                                                    .withOpacity(0.15),
                                                widget.selectedColor
                                                    .withOpacity(0.05),
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                          )
                                        : null,
                                    child: Icon(
                                      item.icon,
                                      size: isSelected ? 26 : 24,
                                      color: isSelected
                                          ? widget.selectedColor
                                          : widget.unselectedColor,
                                    ),
                                  ),
                                  // Badge
                                  if (item.badge != null)
                                    Positioned(
                                      right: -6,
                                      top: -6,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFEF4444),
                                              Color(0xFFDC2626),
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFEF4444,
                                              ).withOpacity(0.5),
                                              blurRadius: 6,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Text(
                                          item.badge!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Label
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  fontSize: isSelected ? 11 : 10,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? widget.selectedColor
                                      : widget.unselectedColor,
                                  letterSpacing: 0.3,
                                ),
                                child: Text(item.label),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
