import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../screens/category_screen.dart';

class ModernTechCarousel extends StatefulWidget {
  const ModernTechCarousel({Key? key}) : super(key: key);

  @override
  State<ModernTechCarousel> createState() => _ModernTechCarouselState();
}

class _ModernTechCarouselState extends State<ModernTechCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  final List<Map<String, dynamic>> techItems = [
    {
      'title': 'Featured Categories',
      'subtitle': 'Premium Laptops',
      'description':
          'Discover our collection of high-performance laptops for work and gaming',
      'image': 'images/image_682x427_237.png',
      'category': 'Laptops',
      'accentColor': Color(0xFF2563EB),
    },
    {
      'title': 'iPhone 17 Pro',
      'subtitle': 'Cosmic Orange',
      'description':
          'Experience the stunning Cosmic Orange finish with advanced Pro features',
      'image': 'images/iPhone_17_Pro_cosmic_orange_finish_partial_back_ex.jpg',
      'category': 'Phones',
      'accentColor': Color(0xFFFF6B35),
    },
    {
      'title': 'iPhone Air',
      'subtitle': 'Space Black',
      'description':
          'Sleek and powerful iPhone Air in elegant Space Black design',
      'image': 'images/iPhone_Air_back_exterior_Space_Black_color_top_rou.jpg',
      'category': 'Phones',
      'accentColor': Color(0xFF1E293B),
    },
    {
      'title': 'iPhone 17 Pro',
      'subtitle': 'Multiple Models',
      'description':
          'Choose from our range of iPhone 17 Pro models with cutting-edge technology',
      'image': 'images/3_iPhone_17_Pro_models_front_exterior_side_by_side.jpg',
      'category': 'Phones',
      'accentColor': Color(0xFF3B82F6),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: techItems.length,
          itemBuilder: (context, index, realIndex) {
            final item = techItems[index];
            return _buildCarouselItem(item, index);
          },
          options: CarouselOptions(
            height: 235,
            aspectRatio: 18 / 9,
            viewportFraction: 0.88,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 650),
            enlargeCenterPage: true,
            enlargeFactor: 0.18,
            enableInfiniteScroll: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),

        const SizedBox(height: 20),

        // Modern Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: techItems.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: _currentIndex == entry.key ? 32 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: _currentIndex == entry.key
                      ? LinearGradient(
                          colors: [
                            techItems[entry.key]['accentColor'],
                            techItems[entry.key]['accentColor'].withOpacity(
                              0.7,
                            ),
                          ],
                        )
                      : null,
                  color: _currentIndex == entry.key
                      ? null
                      : Colors.grey.withOpacity(0.3),
                  boxShadow: _currentIndex == entry.key
                      ? [
                          BoxShadow(
                            color: techItems[entry.key]['accentColor']
                                .withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(Map<String, dynamic> item, int index) {
    final isActive = _currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: item['accentColor'].withOpacity(isActive ? 0.35 : 0.15),
            blurRadius: isActive ? 24 : 12,
            spreadRadius: isActive ? 2 : 0,
            offset: Offset(0, isActive ? 12 : 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image with scale animation
            AnimatedScale(
              scale: isActive ? 1.0 : 0.95,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: Image.asset(
                item['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.grey[300]!, Colors.grey[400]!],
                      ),
                    ),
                    child: const Icon(
                      Icons.image_not_supported_rounded,
                      size: 50,
                      color: Colors.white54,
                    ),
                  );
                },
              ),
            ),

            // Enhanced gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.75),
                      Colors.black.withOpacity(0.92),
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            // Subtle top gradient for depth
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Subtitle with animated badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            item['subtitle'].toString().toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.95),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Title with text shadow
                        Text(
                          item['title'],
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Description with better readability
                        Text(
                          item['description'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Bottom CTA with hover effect
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryScreen(categoryName: item['category']),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.95),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 16,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: item['accentColor'].withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: item['accentColor'],
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: item['accentColor'].withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: item['accentColor'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
