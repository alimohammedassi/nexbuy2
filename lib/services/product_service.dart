import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import 'api_service.dart';
import '../config/api_config.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  final ApiService _apiService = ApiService();
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Product> _products = [];
  List<Product> _featuredProducts = [];

  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;

  // Fetch all products from Supabase with timeout
  Future<bool> fetchProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              debugPrint('Fetch products timed out after 10 seconds');
              throw TimeoutException('Product fetch timed out');
            },
          );

      // Handle the response properly
      if (response is List) {
        _products = response
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
        debugPrint('Successfully fetched ${_products.length} products');
        return true;
      } else {
        debugPrint('Unexpected response type: ${response.runtimeType}');
        _products = [];
        return false;
      }
    } catch (e) {
      debugPrint('Fetch products error: $e');
      _products = [];
      return false;
    }
  }

  // Fetch featured products from Supabase
  Future<bool> fetchFeaturedProducts() async {
    try {
      // Assuming featured products are those with high rating or specific flag
      // For now, let's just take top rated ones
      final response = await _supabase
          .from('products')
          .select()
          .order('rating', ascending: false)
          .limit(10);

      _featuredProducts = (response as List)
          .map((productJson) => Product.fromJson(productJson))
          .toList();
      return true;
    } catch (e) {
      debugPrint('Fetch featured products error: $e');
      return false;
    }
  }

  // Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search products
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;

    return _products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.brand.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Get products by category
  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  // Fetch products by category from Supabase
  Future<List<Product>> fetchProductsByCategory(String category) async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('category', category);

      final items = (response as List).map((e) => Product.fromJson(e)).toList();

      // Optionally merge into cache
      if (items.isNotEmpty) {
        _products = {
          ...{for (final p in _products) p.id: p},
          ...{for (final p in items) p.id: p},
        }.values.toList();
      }

      return items;
    } catch (e) {
      debugPrint('Fetch products by category error: $e');
      return [];
    }
  }

  // Get products by brand
  List<Product> getProductsByBrand(String brand) {
    return _products.where((product) => product.brand == brand).toList();
  }

  // Add product to favorites (if API supports it)
  Future<bool> toggleFavorite(String productId) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.productsEndpoint}/$productId/favorite',
      );

      if (response['success'] == true) {
        // Update local product
        final productIndex = _products.indexWhere((p) => p.id == productId);
        if (productIndex != -1) {
          _products[productIndex] = _products[productIndex].copyWith(
            isFavorite: !_products[productIndex].isFavorite,
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Toggle favorite error: $e');
      return false;
    }
  }

  // Stock quantity management

  /// Check if product has sufficient stock
  Future<bool> checkStockAvailability(
    String productId,
    int requestedQuantity,
  ) async {
    try {
      final response = await _supabase
          .from('products')
          .select('stock_quantity')
          .eq('id', productId)
          .maybeSingle();

      if (response == null) {
        debugPrint('Product not found: $productId');
        return false;
      }

      final stockQuantity = response['stock_quantity'] as int? ?? 0;
      return stockQuantity >= requestedQuantity;
    } catch (e) {
      debugPrint('Error checking stock availability: $e');
      return false;
    }
  }

  /// Update stock quantity (admin only)
  Future<bool> updateStockQuantity(String productId, int newQuantity) async {
    try {
      await _supabase
          .from('products')
          .update({'stock_quantity': newQuantity})
          .eq('id', productId);

      // Update local cache
      final productIndex = _products.indexWhere((p) => p.id == productId);
      if (productIndex != -1) {
        _products[productIndex] = _products[productIndex].copyWith(
          stockQuantity: newQuantity,
        );
      }

      debugPrint('Updated stock quantity for $productId to $newQuantity');
      return true;
    } catch (e) {
      debugPrint('Error updating stock quantity: $e');
      return false;
    }
  }

  /// Decrease stock quantity after order (called by checkout)
  Future<bool> decreaseStock(String productId, int quantity) async {
    try {
      // Get current stock
      final response = await _supabase
          .from('products')
          .select('stock_quantity')
          .eq('id', productId)
          .single();

      final currentStock = response['stock_quantity'] as int? ?? 0;
      final newStock = currentStock - quantity;

      if (newStock < 0) {
        debugPrint('Insufficient stock for product $productId');
        return false;
      }

      await _supabase
          .from('products')
          .update({'stock_quantity': newStock})
          .eq('id', productId);

      debugPrint('Decreased stock for $productId by $quantity');
      return true;
    } catch (e) {
      debugPrint('Error decreasing stock: $e');
      return false;
    }
  }

  /// Increase stock quantity (for returns/cancellations)
  Future<bool> increaseStock(String productId, int quantity) async {
    try {
      final response = await _supabase
          .from('products')
          .select('stock_quantity')
          .eq('id', productId)
          .single();

      final currentStock = response['stock_quantity'] as int? ?? 0;
      final newStock = currentStock + quantity;

      await _supabase
          .from('products')
          .update({'stock_quantity': newStock})
          .eq('id', productId);

      debugPrint('Increased stock for $productId by $quantity');
      return true;
    } catch (e) {
      debugPrint('Error increasing stock: $e');
      return false;
    }
  }
}
