import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class FirestoreProductService {
  static final FirestoreProductService _instance =
      FirestoreProductService._internal();
  factory FirestoreProductService() => _instance;
  FirestoreProductService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  final String _table = 'products';

  /// Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _supabase.from(_table).select().order('name');

      final products = (response as List)
          .map((data) => _productFromSupabase(data))
          .toList();

      return products;
    } catch (e) {
      debugPrint('Error fetching products: $e');
      return [];
    }
  }

  /// Get products stream (real-time updates)
  Stream<List<Product>> getProductsStream() {
    return _supabase
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('name')
        .map((data) {
          final products = data
              .map((item) => _productFromSupabase(item))
              .toList();
          return products.reversed.toList();
        })
        .handleError((error) {
          debugPrint('Error in products stream: $error');
          return <Product>[];
        });
  }

  /// Get product by ID
  Future<Product?> getProductById(String id) async {
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .eq('id', id)
          .single();

      return _productFromSupabase(response);
    } catch (e) {
      debugPrint('Error fetching product: $e');
      return null;
    }
  }

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String categoryName) async {
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .eq('category', categoryName)
          .order('name');

      final products = (response as List)
          .map((data) => _productFromSupabase(data))
          .toList();

      return products;
    } catch (e) {
      debugPrint('Error fetching products by category: $e');
      return [];
    }
  }

  /// Get products by category stream (real-time updates)
  Stream<List<Product>> getProductsByCategoryStream(String categoryName) {
    return _supabase
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('category', categoryName)
        .order('name')
        .map((data) {
          return data.map((item) => _productFromSupabase(item)).toList();
        })
        .handleError((error) {
          debugPrint('Error in category products stream: $error');
          return <Product>[];
        });
  }

  Future<List<Product>> getProductsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    try {
      debugPrint('Fetching products for IDs: $ids');

      // Attempt efficient query
      // Note: Passing a List to filter's value for 'in' operator relies on SDK serialization.
      // If this fails (returns empty), we fall back to manual filtering.
      final response = await _supabase
          .from(_table)
          .select()
          .filter('id', 'in', ids);

      final products = (response as List)
          .map((data) => _productFromSupabase(data))
          .toList();

      if (products.isNotEmpty) {
        debugPrint('Found ${products.length} products via direct query');
        return products;
      }

      debugPrint(
        'Direct query returned empty. Falling back to client-side filtering.',
      );

      // Fallback: Fetch all and filter (Guaranteed to work if IDs depend on specific formatting)
      final allResponse = await _supabase.from(_table).select();
      final allProducts = (allResponse as List)
          .map((data) => _productFromSupabase(data))
          .toList();

      final filtered = allProducts.where((p) => ids.contains(p.id)).toList();
      debugPrint('Found ${filtered.length} products via client-side filtering');
      return filtered;
    } catch (e) {
      debugPrint('Error fetching products by IDs: $e');

      // One last attempt - try fetching all and filtering, in case the filter caused the error
      try {
        final allResponse = await _supabase.from(_table).select();
        final allProducts = (allResponse as List)
            .map((data) => _productFromSupabase(data))
            .toList();
        return allProducts.where((p) => ids.contains(p.id)).toList();
      } catch (e2) {
        debugPrint('Fallback error: $e2');
        return [];
      }
    }
  }

  /// Add new product
  Future<String> addProduct(Product product) async {
    try {
      final productData = _productToSupabase(product);

      // Generate a unique ID if empty or null
      String productId = product.id;
      if (productId.isEmpty || productId == '') {
        // Generate unique ID using timestamp + random number
        productId =
            'prod_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch}';
      }
      productData['id'] = productId;

      // Remove createdAt and updatedAt - they're handled by database defaults/triggers
      productData.remove('created_at');
      productData.remove('updated_at');

      final response = await _supabase
          .from(_table)
          .insert(productData)
          .select()
          .single();

      return response['id']?.toString() ?? productId;
    } catch (e) {
      debugPrint('Error adding product: $e');
      throw Exception('Failed to add product: $e');
    }
  }

  /// Update product
  Future<void> updateProduct(Product product) async {
    try {
      final productData = _productToSupabase(product);
      // Remove updated_at - it's handled by database trigger
      // productData['updated_at'] = DateTime.now().toIso8601String();

      await _supabase.from(_table).update(productData).eq('id', product.id);
    } catch (e) {
      debugPrint('Error updating product: $e');
      throw Exception('Failed to update product: $e');
    }
  }

  /// Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _supabase.from(_table).delete().eq('id', productId);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  /// Convert Supabase data to Product
  Product _productFromSupabase(Map<String, dynamic> data) {
    // Handle price conversion (can be num, double, or string)
    double price = 0.0;
    if (data['price'] != null) {
      if (data['price'] is num) {
        price = (data['price'] as num).toDouble();
      } else if (data['price'] is String) {
        price = double.tryParse(data['price']) ?? 0.0;
      }
    }

    // Handle rating conversion
    double rating = 4.5;
    if (data['rating'] != null) {
      if (data['rating'] is num) {
        rating = (data['rating'] as num).toDouble();
      } else if (data['rating'] is String) {
        rating = double.tryParse(data['rating']) ?? 4.5;
      }
    }

    return Product(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      price: price,
      rating: rating,
      imagePath:
          data['image_path']?.toString() ?? data['imagePath']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      isFavorite: data['is_favorite'] ?? data['isFavorite'] ?? false,
      features: List<String>.from(data['features'] ?? []),
      brand: data['brand']?.toString() ?? '',
      model: data['model']?.toString() ?? '',
      specifications: Map<String, String>.from(data['specifications'] ?? {}),
      stockQuantity: data['stock_quantity'] ?? 0,
    );
  }

  /// Convert Product to Supabase data
  Map<String, dynamic> _productToSupabase(Product product) {
    return {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'rating': product.rating,
      'image_path': product.imagePath,
      'category': product.category,
      'is_favorite': product.isFavorite,
      'features': product.features,
      'brand': product.brand,
      'model': product.model,
      'specifications': product.specifications,
      'stock_quantity': product.stockQuantity,
    };
  }
}
