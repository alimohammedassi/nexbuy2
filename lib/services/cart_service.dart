import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal() {
    _loadCartFromDatabase();
  }

  final SupabaseClient _supabase = Supabase.instance.client;
  final List<CartItem> _cartItems = [];
  final StreamController<List<CartItem>> _cartController =
      StreamController<List<CartItem>>.broadcast();

  Stream<List<CartItem>> get cartStream => _cartController.stream;

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  /// Load cart items from database for logged-in users
  Future<void> _loadCartFromDatabase() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in, cart will be local only');
        return;
      }

      // Fetch cart items with product details
      final response = await _supabase
          .from('cart_items')
          .select('*, products(*)')
          .eq('user_id', user.id);

      _cartItems.clear();

      // Ensure response is a list
      if (response is! List) {
        _cartController.add([]);
        return;
      }

      for (var item in response) {
        final product = item['products'];
        if (product != null) {
          _cartItems.add(
            CartItem(
              id: item['id']?.toString() ?? '',
              productId: item['product_id']?.toString() ?? '',
              productName: product['name']?.toString() ?? 'Unknown Product',
              productImage: product['image_path']?.toString() ?? '',
              price: (product['price'] as num?)?.toDouble() ?? 0.0,
              quantity: item['quantity'] as int? ?? 1,
              variant: item['variant']?.toString(),
            ),
          );
        } else {
          debugPrint(
            'Cart item ${item['id']} has no product data - product may have been deleted',
          );
        }
      }

      _cartController.add(List.from(_cartItems));
      debugPrint('Loaded ${_cartItems.length} cart items from database');
    } catch (e, stackTrace) {
      debugPrint('Error loading cart from database: $e');
      debugPrint('Stack trace: $stackTrace');
      // Ensure stream gets updated even on error
      _cartController.add([]);
    }
  }

  /// Clear local state (used when logging out)
  void clearLocalState() {
    _cartItems.clear();
    _cartController.add([]);
    debugPrint('Cleared local cart state');
  }

  /// Refresh cart from database
  Future<void> refreshCart() async {
    await _loadCartFromDatabase();
  }

  void addToCart({
    required String productId,
    required String productName,
    required String productImage,
    required double price,
    int quantity = 1,
    String? variant,
  }) async {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.productId == productId && item.variant == variant,
    );

    if (existingItemIndex != -1) {
      // Update existing item
      final updatedItem = _cartItems[existingItemIndex].copyWith(
        quantity: _cartItems[existingItemIndex].quantity + quantity,
      );
      _cartItems[existingItemIndex] = updatedItem;

      // Update in database
      await _updateCartItemInDatabase(updatedItem);
    } else {
      // Add new item
      final newItem = CartItem(
        productId: productId,
        productName: productName,
        productImage: productImage,
        price: price,
        quantity: quantity,
        variant: variant,
      );
      _cartItems.add(newItem);

      // Insert into database
      await _insertCartItemToDatabase(newItem);
    }

    _cartController.add(List.from(_cartItems));
  }

  void removeFromCart(String productId, {String? variant}) async {
    final item = _cartItems.firstWhere(
      (item) => item.productId == productId && item.variant == variant,
      orElse: () => CartItem(
        productId: '',
        productName: '',
        productImage: '',
        price: 0,
        quantity: 0,
      ),
    );

    _cartItems.removeWhere(
      (item) => item.productId == productId && item.variant == variant,
    );

    // Delete from database
    if (item.id.isNotEmpty) {
      await _deleteCartItemFromDatabase(item.id);
    }

    _cartController.add(List.from(_cartItems));
  }

  void updateQuantity(String productId, int quantity, {String? variant}) async {
    final itemIndex = _cartItems.indexWhere(
      (item) => item.productId == productId && item.variant == variant,
    );

    if (itemIndex != -1) {
      if (quantity <= 0) {
        final item = _cartItems[itemIndex];
        _cartItems.removeAt(itemIndex);
        if (item.id.isNotEmpty) {
          await _deleteCartItemFromDatabase(item.id);
        }
      } else {
        final updatedItem = _cartItems[itemIndex].copyWith(quantity: quantity);
        _cartItems[itemIndex] = updatedItem;
        await _updateCartItemInDatabase(updatedItem);
      }
    }
    _cartController.add(List.from(_cartItems));
  }

  void clearCart() async {
    _cartItems.clear();
    _cartController.add(List.from(_cartItems));

    // Clear from database
    await _clearCartInDatabase();
  }

  bool isInCart(String productId, {String? variant}) {
    return _cartItems.any(
      (item) => item.productId == productId && item.variant == variant,
    );
  }

  int getItemQuantity(String productId, {String? variant}) {
    final item = _cartItems.firstWhere(
      (item) => item.productId == productId && item.variant == variant,
      orElse: () => CartItem(
        productId: '',
        productName: '',
        productImage: '',
        price: 0,
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  // Database operations

  Future<void> _insertCartItemToDatabase(CartItem item) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in, skipping database insert');
        return;
      }

      final response = await _supabase
          .from('cart_items')
          .insert({
            'user_id': user.id,
            'product_id': item.productId,
            'quantity': item.quantity,
          })
          .select()
          .single();

      // Update local item with database ID
      final index = _cartItems.indexWhere((i) => i.productId == item.productId);
      if (index != -1) {
        _cartItems[index] = CartItem(
          id: response['id'].toString(),
          productId: item.productId,
          productName: item.productName,
          productImage: item.productImage,
          price: item.price,
          quantity: item.quantity,
          variant: item.variant,
        );
      }

      debugPrint('Inserted cart item to database');
    } catch (e) {
      debugPrint('Error inserting cart item to database: $e');
    }
  }

  Future<void> _updateCartItemInDatabase(CartItem item) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null || item.id.isEmpty) {
        debugPrint(
          'No user logged in or item has no ID, skipping database update',
        );
        return;
      }

      await _supabase
          .from('cart_items')
          .update({'quantity': item.quantity})
          .eq('id', item.id)
          .eq('user_id', user.id);

      debugPrint('Updated cart item in database');
    } catch (e) {
      debugPrint('Error updating cart item in database: $e');
    }
  }

  Future<void> _deleteCartItemFromDatabase(String itemId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in, skipping database delete');
        return;
      }

      await _supabase
          .from('cart_items')
          .delete()
          .eq('id', itemId)
          .eq('user_id', user.id);

      debugPrint('Deleted cart item from database');
    } catch (e) {
      debugPrint('Error deleting cart item from database: $e');
    }
  }

  Future<void> _clearCartInDatabase() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in, skipping database clear');
        return;
      }

      await _supabase.from('cart_items').delete().eq('user_id', user.id);

      debugPrint('Cleared cart in database');
    } catch (e) {
      debugPrint('Error clearing cart in database: $e');
    }
  }

  void dispose() {
    _cartController.close();
  }
}
