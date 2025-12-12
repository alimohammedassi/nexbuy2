import 'package:flutter/material.dart';
import 'package:fade_shimmer/fade_shimmer.dart';

/// Shimmer loading widget for product cards
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image shimmer
            FadeShimmer(
              height: 100,
              width: 100,
              radius: 16,
              highlightColor: const Color(0xFFF0F9FF),
              baseColor: const Color(0xFFE5E7EB),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title shimmer
                  FadeShimmer(
                    height: 16,
                    width: double.infinity,
                    radius: 4,
                    highlightColor: const Color(0xFFF0F9FF),
                    baseColor: const Color(0xFFE5E7EB),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle shimmer
                  FadeShimmer(
                    height: 14,
                    width: 120,
                    radius: 4,
                    highlightColor: const Color(0xFFF0F9FF),
                    baseColor: const Color(0xFFE5E7EB),
                  ),
                  const SizedBox(height: 12),
                  // Price shimmer
                  FadeShimmer(
                    height: 20,
                    width: 80,
                    radius: 8,
                    highlightColor: const Color(0xFFF0F9FF),
                    baseColor: const Color(0xFFE5E7EB),
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

/// Shimmer loading widget for category cards
class CategoryCardShimmer extends StatelessWidget {
  const CategoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image shimmer
          FadeShimmer(
            height: 120,
            width: double.infinity,
            radius: 16,
            highlightColor: const Color(0xFFF0F9FF),
            baseColor: const Color(0xFFE5E7EB),
          ),
          const SizedBox(height: 8),
          // Title shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FadeShimmer(
              height: 14,
              width: double.infinity,
              radius: 4,
              highlightColor: const Color(0xFFF0F9FF),
              baseColor: const Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Shimmer loading widget for list items
class ListItemShimmer extends StatelessWidget {
  const ListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circle avatar shimmer
          FadeShimmer.round(
            size: 50,
            highlightColor: const Color(0xFFF0F9FF),
            baseColor: const Color(0xFFE5E7EB),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeShimmer(
                  height: 14,
                  width: double.infinity,
                  radius: 4,
                  highlightColor: const Color(0xFFF0F9FF),
                  baseColor: const Color(0xFFE5E7EB),
                ),
                const SizedBox(height: 8),
                FadeShimmer(
                  height: 12,
                  width: 150,
                  radius: 4,
                  highlightColor: const Color(0xFFF0F9FF),
                  baseColor: const Color(0xFFE5E7EB),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer loading widget for grid items
class GridItemShimmer extends StatelessWidget {
  const GridItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer
          FadeShimmer(
            height: 150,
            width: double.infinity,
            radius: 16,
            highlightColor: const Color(0xFFF0F9FF),
            baseColor: const Color(0xFFE5E7EB),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                FadeShimmer(
                  height: 14,
                  width: double.infinity,
                  radius: 4,
                  highlightColor: const Color(0xFFF0F9FF),
                  baseColor: const Color(0xFFE5E7EB),
                ),
                const SizedBox(height: 8),
                // Price shimmer
                FadeShimmer(
                  height: 16,
                  width: 80,
                  radius: 4,
                  highlightColor: const Color(0xFFF0F9FF),
                  baseColor: const Color(0xFFE5E7EB),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Generic text shimmer
class TextShimmer extends StatelessWidget {
  final double width;
  final double height;

  const TextShimmer({super.key, this.width = 100, this.height = 14});

  @override
  Widget build(BuildContext context) {
    return FadeShimmer(
      height: height,
      width: width,
      radius: 4,
      highlightColor: const Color(0xFFF0F9FF),
      baseColor: const Color(0xFFE5E7EB),
    );
  }
}

/// Loading shimmer for entire screen
class ScreenLoadingShimmer extends StatelessWidget {
  const ScreenLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F4F7),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          FadeShimmer(
            height: 40,
            width: 200,
            radius: 8,
            highlightColor: const Color(0xFFF0F9FF),
            baseColor: const Color(0xFFE5E7EB),
          ),
          const SizedBox(height: 20),
          // List items
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const ProductCardShimmer(),
            ),
          ),
        ],
      ),
    );
  }
}
