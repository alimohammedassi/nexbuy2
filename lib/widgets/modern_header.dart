import 'package:flutter/material.dart';

class ModernHeader extends StatefulWidget {
  final int cartItemCount;
  final VoidCallback? onCartPressed;
  final bool useAnimatedLogo;

  const ModernHeader({
    super.key,
    this.cartItemCount = 0,
    this.onCartPressed,
    this.useAnimatedLogo = true,
  });

  @override
  State<ModernHeader> createState() => _ModernHeaderState();
}

class _ModernHeaderState extends State<ModernHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Centered logo
          Center(child: _buildModernLogo()),
          // Cart button in top right corner
          Positioned(top: 0, right: 0, child: _buildCartButton()),
        ],
      ),
    );
  }

  Widget _buildModernLogo() {
    return widget.useAnimatedLogo
        ? Image.asset(
            'images/logo with logo.gif',
            height: 80,
            width: 300,

            // errorBuilder: (context, error, stackTrace) {
            //   // return Container(
            //   //   padding: const EdgeInsets.all(12),
            //   //   decoration: BoxDecoration(
            //   //     gradient: const LinearGradient(
            //   //       colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            //   //       begin: Alignment.topLeft,
            //   //       end: Alignment.bottomRight,
            //   //     ),
            //   //     borderRadius: BorderRadius.circular(16),
            //   //   ),
            //   // );
            // },
          )
        : Image.asset(
            'images/logo with logo.gif',
            height: 100,
            width: 300,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          );
  }

  Widget _buildCartButton() {
    return GestureDetector(
      onTap: widget.onCartPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 33, 36, 228),
              Color.fromARGB(255, 24, 67, 178),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 20,
            ),
            // Cart badge
            if (widget.cartItemCount > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    widget.cartItemCount > 99
                        ? '99+'
                        : widget.cartItemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
