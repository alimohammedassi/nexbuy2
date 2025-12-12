import 'package:flutter/foundation.dart';
import '../services/product_service.dart';
import '../models/product.dart';

class ProductProvider {
  // Initial mock data as fallback - will be replaced by database data
  static List<Product> _laptops = [
    Product(
      id: 'mock_1',
      name: 'Loading Products...',
      description: 'Fetching from database',
      price: 0.0,
      rating: 4.5,
      imagePath:
          'images/Apple_2023_Newest_MacBook_Pro_MR7J3_Laptop_M3_chip.jpg',
      category: 'Laptops',
      features: [],
      brand: 'Loading',
      model: 'Please wait',
      specifications: {},
    ),
  ];

  static List<Product> _phones = [
    Product(
      id: 'mock_2',
      name: 'Loading Products...',
      description: 'Fetching from database',
      price: 0.0,
      rating: 4.5,
      imagePath:
          'images/phone/_iPhone_17_Pro_Max_256_GB_Cosmic_Orange_5G_eSim_on.jpg',
      category: 'Phones',
      features: [],
      brand: 'Loading',
      model: 'Please wait',
      specifications: {},
    ),
  ];

  static Future<void> initialize() async {
    try {
      final productService = ProductService();
      final success = await productService.fetchProducts();

      if (success) {
        final allProducts = productService.products;

        _laptops = allProducts
            .where((p) => p.category.toLowerCase() == 'laptops')
            .toList();
        _phones = allProducts
            .where(
              (p) =>
                  p.category.toLowerCase() == 'smartphones' ||
                  p.category.toLowerCase() == 'phones',
            )
            .toList();

        debugPrint(
          'ProductProvider initialized with ${_laptops.length} laptops and ${_phones.length} phones',
        );
      } else {
        debugPrint(
          'Failed to fetch products from database, using fallback data',
        );
      }
    } catch (e) {
      debugPrint('Error initializing ProductProvider: $e');
      // Keep fallback data on error
    }
  }

  static List<Product> get laptops => _laptops;
  static List<Product> get phones => _phones;
  static List<Product> get allProducts => [..._laptops, ..._phones];

  static List<Product> get featuredLaptops => _laptops.take(4).toList();
  static List<Product> get featuredPhones => _phones.take(4).toList();

  static List<Product> get favoriteLaptops =>
      _laptops.where((laptop) => laptop.isFavorite).toList();

  static Product? getLaptopById(String id) {
    try {
      return _laptops.firstWhere((laptop) => laptop.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Product> searchLaptops(String query) {
    if (query.isEmpty) return _laptops;

    return _laptops.where((laptop) {
      return laptop.name.toLowerCase().contains(query.toLowerCase()) ||
          laptop.brand.toLowerCase().contains(query.toLowerCase()) ||
          laptop.model.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Add a new product and return the inserted product (with ensured unique id if needed)
  static Product addProduct(Product product) {
    // Ensure unique id if caller didn't
    final bool idExists = _laptops.any((p) => p.id == product.id);
    if (idExists) {
      final String newId = DateTime.now().millisecondsSinceEpoch.toString();
      final Product withUniqueId = product.copyWith(id: newId);
      _laptops.add(withUniqueId);
      return withUniqueId;
    }
    _laptops.add(product);
    return product;
  }

  // Convenience: add product to the start of the list (shows first in some UIs)
  static Product prependProduct(Product product) {
    final bool idExists = _laptops.any((p) => p.id == product.id);
    if (idExists) {
      final String newId = DateTime.now().millisecondsSinceEpoch.toString();
      final Product withUniqueId = product.copyWith(id: newId);
      _laptops.insert(0, withUniqueId);
      return withUniqueId;
    }
    _laptops.insert(0, product);
    return product;
  }

  // Filter by category name (case-insensitive)
  static List<Product> byCategory(String categoryName) {
    return allProducts
        .where((p) => p.category.toLowerCase() == categoryName.toLowerCase())
        .toList();
  }

  // Get product by ID from all products
  static Product? getProductById(String id) {
    try {
      return allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search all products
  static List<Product> searchProducts(String query) {
    if (query.isEmpty) return allProducts;

    return allProducts.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.brand.toLowerCase().contains(query.toLowerCase()) ||
          product.model.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
