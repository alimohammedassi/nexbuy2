import 'dart:ui' show window;

class Category {
  final String id;
  final String nameEn;
  final String nameAr;
  final String imageUrl;
  final String? description;

  const Category({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.imageUrl,
    this.description,
  });

  // Get localized name based on current locale
  String get name {
    // Try to get locale from platform, default to English
    try {
      final locale = window.locale.languageCode;
      return locale == 'ar' ? nameAr : nameEn;
    } catch (e) {
      return nameEn; // Default to English if locale detection fails
    }
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? json['name'] as String? ?? '',
      imageUrl:
          json['imageUrl'] as String? ?? json['image_url'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': nameEn,
      'name_ar': nameAr,
      'imageUrl': imageUrl,
      'image_url': imageUrl,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Category(id: $id, nameEn: $nameEn, nameAr: $nameAr, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
