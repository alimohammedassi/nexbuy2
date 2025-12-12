class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String imagePath;
  final String category;
  final bool isFavorite;
  final List<String> features;
  final String brand;
  final String model;
  final Map<String, String> specifications;
  final int stockQuantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.category,
    this.isFavorite = false,
    required this.features,
    required this.brand,
    required this.model,
    required this.specifications,
    this.stockQuantity = 0,
  });

  // Helper methods for stock management
  bool get isInStock => stockQuantity > 0;
  bool get isLowStock => stockQuantity > 0 && stockQuantity <= 5;

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? rating,
    String? imagePath,
    String? category,
    bool? isFavorite,
    List<String>? features,
    String? brand,
    String? model,
    Map<String, String>? specifications,
    int? stockQuantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      features: features ?? this.features,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      specifications: specifications ?? this.specifications,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    // Safely parse features from JSONB
    List<String> parseFeatures(dynamic featuresData) {
      if (featuresData == null) return [];
      if (featuresData is List) {
        return featuresData.map((e) => e.toString()).toList();
      }
      return [];
    }

    // Safely parse specifications from JSONB
    Map<String, String> parseSpecifications(dynamic specsData) {
      if (specsData == null) return {};
      if (specsData is Map) {
        return specsData.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        );
      }
      return {};
    }

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      rating: double.tryParse(json['rating']?.toString() ?? '4.5') ?? 4.5,
      imagePath:
          json['imagePath'] ??
          json['image'] ??
          json['image_path'] ??
          'images/iPhone_17_Pro_cosmic_orange_finish_partial_back_ex.jpg',
      category: json['category'] ?? 'Electronics',
      isFavorite: json['isFavorite'] ?? json['is_favorite'] ?? false,
      features: parseFeatures(json['features']),
      brand: json['brand'] ?? 'NexBuy',
      model: json['model'] ?? '',
      specifications: parseSpecifications(json['specifications']),
      stockQuantity:
          int.tryParse(json['stock_quantity']?.toString() ?? '0') ?? 0,
    );
  }
}
