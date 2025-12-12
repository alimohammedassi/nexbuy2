import 'package:flutter/material.dart';
import 'dart:math' as math;

class FeaturedProductsSection extends StatefulWidget {
  const FeaturedProductsSection({super.key});

  @override
  State<FeaturedProductsSection> createState() =>
      _FeaturedProductsSectionState();
}

class _FeaturedProductsSectionState extends State<FeaturedProductsSection>
    with TickerProviderStateMixin {
  late AnimationController _bannerController;
  late AnimationController _carouselController;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  final List<FeaturedProduct> _featuredProducts = [
    FeaturedProduct(
      id: '1',
      name: 'iPhone 17 Lavender',
      tagline: 'Supercharged for pros',
      description: 'Latest iPhone with stunning lavender finish',
      price: 999.00,
      discount: 15,
      image:
          'images/cards_iphone/iPhone_17_in_Lavender_finish_partial-screen_displa.jpg',
      badge: 'NEW',
      gradient: [Color(0xFF667eea), Color(0xFF764ba2)],
    ),
    FeaturedProduct(
      id: '2',
      name: 'iPhone 17 Pro Cosmic Orange',
      tagline: 'Limited edition finish',
      description: 'Exclusive cosmic orange titanium design',
      price: 1199.00,
      discount: 10,
      image:
          'images/cards_iphone/iPhone_17_Pro_in_cosmic_orange_finish_showing_part.jpg',
      badge: 'HOT',
      gradient: [Color(0xFFf093fb), Color(0xFFF5576C)],
    ),
    FeaturedProduct(
      id: '3',
      name: 'iPhone 17 Pro Models',
      tagline: 'Front exterior lineup',
      description: 'Complete iPhone 17 Pro collection',
      price: 1099.00,
      discount: 5,
      image: 'images/3_iPhone_17_Pro_models_front_exterior_side_by_side.jpg',
      badge: 'SALE',
      gradient: [Color(0xFF4facfe), Color(0xFF00f2fe)],
    ),
    FeaturedProduct(
      id: '4',
      name: 'Premium Smartphone',
      tagline: 'Latest technology',
      description: 'Advanced smartphone with cutting-edge features',
      price: 899.00,
      discount: 20,
      image: 'images/1311209143 (3).png',
      badge: 'FEATURED',
      gradient: [Color(0xFF667eea), Color(0xFF764ba2)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _carouselController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _carouselController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        _buildProductCarousel(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildProductCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 420,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _featuredProducts.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeInOut.transform(value) * 420,
                      child: child,
                    ),
                  );
                },
                child: _buildProductCard(_featuredProducts[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _featuredProducts.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 32 : 8,
              height: 8,
              decoration: BoxDecoration(
                gradient: _currentPage == index
                    ? const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                      )
                    : null,
                color: _currentPage != index ? Colors.grey[300] : null,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(FeaturedProduct product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: product.gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Gradient overlay for better text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    end: Alignment.bottomLeft,
                    colors: [Colors.black.withValues(alpha: 0.3), Colors.black],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.badge,
                          style: const TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.tagline,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.discount > 0)
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              '\$${(product.price * (1 - product.discount / 100)).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Shop Now',
                              style: const TextStyle(
                                color: Color(0xFF2563EB),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF2563EB),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (product.discount > 0)
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '-${product.discount}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FeaturedProduct {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final double price;
  final int discount;
  final String image;
  final String badge;
  final List<Color> gradient;

  FeaturedProduct({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.discount,
    required this.image,
    required this.badge,
    required this.gradient,
  });
}

class BannerPatternPainter extends CustomPainter {
  final double animation;

  BannerPatternPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final x = size.width * (i / 5) + (animation * 50);
      canvas.drawCircle(
        Offset(x, size.height * 0.5),
        30 + (math.sin(animation * math.pi * 2 + i) * 10),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BannerPatternPainter oldDelegate) => true;
}

class CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw diagonal lines
    for (int i = 0; i < 10; i++) {
      final y = size.height * (i / 10);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + size.height * 0.3),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CardPatternPainter oldDelegate) => false;
}
