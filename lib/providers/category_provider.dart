import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider {
  static final CategoryService _categoryService = CategoryService();

  // Fallback categories in case Supabase is not available
  static final List<Category> _fallbackCategories = [
    const Category(
      id: 'smartphones',
      nameEn: 'Smartphones',
      nameAr: 'الهواتف الذكية',
      imageUrl:
          'images/cards_iphone/iPhone_17_Pro_in_cosmic_orange_finish_showing_part.jpg',
      description: 'Latest smartphones and mobile devices',
    ),
    const Category(
      id: 'laptops',
      nameEn: 'Laptops',
      nameAr: 'أجهزة الكمبيوتر المحمولة',
      imageUrl: 'images/ASUS_Asus_ProArt_P16_H7606WI-ME139W_RyzenAI_9-HX37.jpg',
      description: 'Gaming and professional laptops',
    ),
    const Category(
      id: 'headphones',
      nameEn: 'Headphones',
      nameAr: 'سماعات الرأس',
      imageUrl: 'images/card images.jpg',
      description: 'Wireless and wired headphones',
    ),
    const Category(
      id: 'watches',
      nameEn: 'Watches',
      nameAr: 'الساعات',
      imageUrl: 'images/card images.jpg',
      description: 'Smartwatches and fitness trackers',
    ),
    const Category(
      id: 'tablets',
      nameEn: 'Tablets',
      nameAr: 'الأجهزة اللوحية',
      imageUrl: 'images/Apple_New_2025_MacBook_Air_MW0Y3_13-Inch_Display_A.jpg',
      description: 'Tablets and e-readers',
    ),
    const Category(
      id: 'accessories',
      nameEn: 'Accessories',
      nameAr: 'الإكسسوارات',
      imageUrl: 'images/card images.jpg',
      description: 'Phone cases, chargers, and more',
    ),
  ];

  /// Get categories from service, fallback to hardcoded if not loaded
  static List<Category> get categories {
    if (_categoryService.hasCategories) {
      return _categoryService.categories.cast<Category>();
    }
    return List.unmodifiable(_fallbackCategories);
  }

  /// Initialize and fetch categories from Supabase
  static Future<bool> initialize() async {
    return await _categoryService.fetchCategories();
  }

  /// Get featured categories
  static List<Category> getFeaturedCategories() {
    if (_categoryService.hasCategories) {
      return _categoryService.getFeaturedCategories().cast<Category>();
    }
    return _fallbackCategories.take(6).toList();
  }

  /// Get category by ID
  static Category? getCategoryById(String id) {
    if (_categoryService.hasCategories) {
      return _categoryService.getCategoryById(id);
    }
    try {
      return _fallbackCategories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search categories
  static List<Category> searchCategories(String query) {
    if (_categoryService.hasCategories) {
      return _categoryService.searchCategories(query).cast<Category>();
    }
    if (query.isEmpty) return _fallbackCategories;

    return _fallbackCategories.where((category) {
      return category.name.toLowerCase().contains(query.toLowerCase()) ||
          (category.description?.toLowerCase().contains(query.toLowerCase()) ??
              false);
    }).toList();
  }

  /// Get the category service instance for reactive updates
  static CategoryService get service => _categoryService;
}
