import 'package:flutter/material.dart';
import '../widgets/category_scroll_widget.dart';
import '../providers/category_provider.dart';

/// Example usage of CategoryScrollWidget
/// This demonstrates how to use the CategoryScrollWidget in different scenarios
class CategoryScrollExample extends StatelessWidget {
  const CategoryScrollExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Scroll Examples'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Basic usage with title
            const Text(
              'Example 1: Basic Usage',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            CategoryScrollWidget(
              categories: CategoryProvider.getFeaturedCategories(),
              title: 'Featured Categories',
              onCategoryTap: (category) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selected: ${category.name}'),
                    backgroundColor: const Color(0xFF2563EB),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Example 2: Custom height and padding
            const Text(
              'Example 2: Custom Height',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            CategoryScrollWidget(
              categories: CategoryProvider.categories.take(4).toList(),
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onCategoryTap: (category) {
                print('Category tapped: ${category.name}');
              },
            ),

            const SizedBox(height: 40),

            // Example 3: Without title
            const Text(
              'Example 3: Without Title',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            CategoryScrollWidget(
              categories: CategoryProvider.categories.skip(4).take(6).toList(),
              onCategoryTap: (category) {
                // Navigate to category page or filter products
                Navigator.pushNamed(context, '/category/${category.id}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
