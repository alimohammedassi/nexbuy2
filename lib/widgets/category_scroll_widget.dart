import 'package:flutter/material.dart';
import '../models/category.dart';
import '../localization/app_localizations.dart';

class CategoryScrollWidget extends StatelessWidget {
  final List<Category> categories;
  final Function(Category)? onCategoryTap;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final String? title;

  const CategoryScrollWidget({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.height,
    this.padding,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          height: height ?? 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryItem(context, category, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, Category category, int index) {
    return GestureDetector(
      onTap: () => onCategoryTap?.call(category),
      child: Container(
        width: 80,
        margin: EdgeInsets.only(right: index == categories.length - 1 ? 0 : 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular category icon with image
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  category.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFF8FAFC),
                            const Color(0xFFF1F5F9),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Category name
            Text(
              AppLocalizations.of(context).getCategoryName(category.id),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                letterSpacing: 0.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
