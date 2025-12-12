import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class CategoryService extends ChangeNotifier {
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch all categories from Supabase
  Future<bool> fetchCategories() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _supabase
          .from('categories')
          .select()
          .order('name_en', ascending: true);

      _categories = (response as List)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get category by ID
  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get featured categories (first 6)
  List<Category> getFeaturedCategories() {
    return _categories.take(6).toList();
  }

  /// Search categories
  List<Category> searchCategories(String query) {
    if (query.isEmpty) return _categories;

    return _categories.where((category) {
      return category.name.toLowerCase().contains(query.toLowerCase()) ||
          (category.description?.toLowerCase().contains(query.toLowerCase()) ??
              false);
    }).toList();
  }

  /// Get categories count
  int get categoriesCount => _categories.length;

  /// Check if categories are loaded
  bool get hasCategories => _categories.isNotEmpty;
}
