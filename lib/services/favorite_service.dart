import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal() {
    _loadFavorites();
  }

  final SupabaseClient _supabase = Supabase.instance.client;
  final Set<String> _favoriteIds = {};
  final StreamController<Set<String>> _favoriteController =
      StreamController<Set<String>>.broadcast();

  Stream<Set<String>> get favoriteStream => _favoriteController.stream;

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  int get favoriteCount => _favoriteIds.length;

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  /// Load favorites from database
  Future<void> _loadFavorites() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in, skipping favorites load');
        return;
      }

      final response = await _supabase
          .from('favorites')
          .select('product_id')
          .eq('user_id', user.id);

      _favoriteIds.clear();
      for (var item in response) {
        _favoriteIds.add(item['product_id'] as String);
      }

      _favoriteController.add(Set.from(_favoriteIds));
      debugPrint('Loaded ${_favoriteIds.length} favorites from database');
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      await removeFromFavorites(productId);
    } else {
      await addToFavorites(productId);
    }
  }

  /// Add product to favorites
  Future<void> addToFavorites(String productId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in, adding to local favorites only');
        _favoriteIds.add(productId);
        _favoriteController.add(Set.from(_favoriteIds));
        return;
      }

      // Add to database
      await _supabase.from('favorites').insert({
        'user_id': user.id,
        'product_id': productId,
      });

      // Update local state
      _favoriteIds.add(productId);
      _favoriteController.add(Set.from(_favoriteIds));
      debugPrint('Added product $productId to favorites');
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      // Still add locally even if database fails
      _favoriteIds.add(productId);
      _favoriteController.add(Set.from(_favoriteIds));
    }
  }

  /// Remove product from favorites
  Future<void> removeFromFavorites(String productId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in, removing from local favorites only');
        _favoriteIds.remove(productId);
        _favoriteController.add(Set.from(_favoriteIds));
        return;
      }

      // Remove from database
      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('product_id', productId);

      // Update local state
      _favoriteIds.remove(productId);
      _favoriteController.add(Set.from(_favoriteIds));
      debugPrint('Removed product $productId from favorites');
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
      // Still remove locally even if database fails
      _favoriteIds.remove(productId);
      _favoriteController.add(Set.from(_favoriteIds));
    }
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        await _supabase.from('favorites').delete().eq('user_id', user.id);
      }

      _favoriteIds.clear();
      _favoriteController.add(Set.from(_favoriteIds));
      debugPrint('Cleared all favorites');
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
      _favoriteIds.clear();
      _favoriteController.add(Set.from(_favoriteIds));
    }
  }

  /// Get favorite products from a list
  List<Product> getFavoriteProducts(List<Product> allProducts) {
    return allProducts
        .where((product) => _favoriteIds.contains(product.id))
        .toList();
  }

  /// Reload favorites from database
  Future<void> refreshFavorites() async {
    await _loadFavorites();
  }

  /// Clear local state (used when logging out)
  void clearLocalState() {
    _favoriteIds.clear();
    _favoriteController.add({});
    debugPrint('Cleared local favorites state');
  }

  void dispose() {
    _favoriteController.close();
  }
}
