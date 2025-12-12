import '../models/user.dart' as app_models;
import 'api_service.dart';
import '../config/api_config.dart';
import 'package:gotrue/gotrue.dart' as gotrue;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'cart_service.dart';
import 'favorite_service.dart';

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  app_models.User? _currentUser;
  List<app_models.Order> _orders = [];
  final ApiService _apiService = ApiService();
  String? _authToken;

  app_models.User? get currentUser => _currentUser;
  List<app_models.Order> get orders => _orders;
  String? get authToken => _authToken;

  // Initialize with Supabase user data or sample data
  Future<void> initialize() async {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    if (session != null) {
      // User is logged in, get data from Supabase
      await setCurrentUserFromSupabase(session.user);
      notifyListeners();
    } else {
      // No session, use sample data for development/testing
      _currentUser = app_models.User(
        id: '1',
        name: 'Guest User',
        email: 'guest@example.com',
        phone: null,
        profileImage: null,
        addresses: [],
        orders: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }

    // Create a default address if user has no addresses
    final defaultAddress = _currentUser!.addresses.isNotEmpty
        ? _currentUser!.addresses.first
        : app_models.Address(
            id: 'default',
            title: 'Default Address',
            fullAddress: 'No address set',
            latitude: 0.0,
            longitude: 0.0,
            city: '',
            state: '',
            zipCode: '',
            country: '',
            isDefault: true,
          );

    // Sample orders
    _orders = [
      app_models.Order(
        id: '1',
        orderNumber: 'NEX-2024-001',
        items: [
          app_models.OrderItem(
            id: '1',
            productId: '1',
            productName: 'MacBook Pro 16"',
            productImage:
                'images/Apple_2023_Newest_MacBook_Pro_MR7J3_Laptop_M3_chip.jpg',
            price: 2499.00,
            quantity: 1,
          ),
        ],
        totalAmount: 2499.00,
        status: app_models.OrderStatus.delivered,
        shippingAddress: defaultAddress,
        orderDate: DateTime.now().subtract(const Duration(days: 15)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 10)),
        trackingNumber: 'TRK123456789',
      ),
      app_models.Order(
        id: '2',
        orderNumber: 'NEX-2024-002',
        items: [
          app_models.OrderItem(
            id: '2',
            productId: '2',
            productName: 'MacBook Air 15"',
            productImage:
                'images/Apple_New_2025_MacBook_Air_MC6T4_13-Inch_Display_A.jpg',
            price: 1299.00,
            quantity: 1,
          ),
        ],
        totalAmount: 1299.00,
        status: app_models.OrderStatus.shipped,
        shippingAddress: defaultAddress,
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        trackingNumber: 'TRK987654321',
      ),
      app_models.Order(
        id: '3',
        orderNumber: 'NEX-2024-003',
        items: [
          app_models.OrderItem(
            id: '3',
            productId: '3',
            productName: 'Dell XPS 13',
            productImage:
                'images/DELL_Vostro_3530_Laptop_With_156_Inch_Full_HD_1920.jpg',
            price: 1299.00,
            quantity: 1,
          ),
        ],
        totalAmount: 1299.00,
        status: app_models.OrderStatus.processing,
        shippingAddress: defaultAddress,
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  Future<bool> updateUserName(String newName) async {
    if (_currentUser == null) return false;

    try {
      // Update in Supabase
      final supabase = Supabase.instance.client;
      await supabase.auth.updateUser(
        UserAttributes(data: {'name': newName, 'full_name': newName}),
      );

      // Update local user
      _currentUser = _currentUser!.copyWith(
        name: newName,
        updatedAt: DateTime.now(),
      );

      // Refresh session to get updated metadata
      await supabase.auth.refreshSession();

      // Update from Supabase to get latest data
      final supabaseUser = supabase.auth.currentUser;
      if (supabaseUser != null) {
        await setCurrentUserFromSupabase(supabaseUser);
      }

      return true;
    } catch (e) {
      print('Error updating name: $e');
      return false;
    }
  }

  Future<bool> updateUserEmail(String newEmail) async {
    if (_currentUser == null) return false;

    try {
      // Update in Supabase
      final supabase = Supabase.instance.client;
      await supabase.auth.updateUser(UserAttributes(email: newEmail));

      // Update local user
      _currentUser = _currentUser!.copyWith(
        email: newEmail,
        updatedAt: DateTime.now(),
      );

      // Refresh session
      await supabase.auth.refreshSession();

      // Update from Supabase to get latest data
      final supabaseUser = supabase.auth.currentUser;
      if (supabaseUser != null) {
        await setCurrentUserFromSupabase(supabaseUser);
      }

      return true;
    } catch (e) {
      print('Error updating email: $e');
      return false;
    }
  }

  Future<bool> updateUserPhone(String newPhone) async {
    if (_currentUser == null) return false;

    try {
      // Update in Supabase
      final supabase = Supabase.instance.client;
      await supabase.auth.updateUser(UserAttributes(phone: newPhone));

      // Update local user
      _currentUser = _currentUser!.copyWith(
        phone: newPhone,
        updatedAt: DateTime.now(),
      );

      // Refresh session
      await supabase.auth.refreshSession();

      // Update from Supabase to get latest data
      final supabaseUser = supabase.auth.currentUser;
      if (supabaseUser != null) {
        await setCurrentUserFromSupabase(supabaseUser);
      }

      return true;
    } catch (e) {
      print('Error updating phone: $e');
      return false;
    }
  }

  Future<bool> addAddress(app_models.Address address) async {
    if (_currentUser == null) {
      debugPrint('❌ Cannot add address: No current user');
      return false;
    }

    try {
      final supabase = Supabase.instance.client;
      final userId = _currentUser!.id;

      // Ensure user record exists in public.users table
      final supabaseUser = supabase.auth.currentUser;
      if (supabaseUser != null) {
        await _ensureUserRecordExists(supabaseUser);
      }

      debugPrint('📍 Adding address for user: $userId');
      debugPrint('   Title: ${address.title}');
      debugPrint('   Address: ${address.fullAddress}');
      debugPrint('   Coordinates: ${address.latitude}, ${address.longitude}');

      // If this address should be default, unset all other defaults first
      if (address.isDefault) {
        debugPrint('   Setting as default address...');
        await supabase
            .from('addresses')
            .update({'is_default': false})
            .eq('user_id', userId);
      }

      final data = _addressToSupabase(address, userId);
      debugPrint('   Data to insert: $data');

      final response = await supabase.from('addresses').insert(data).select();
      debugPrint('✅ Address added successfully: $response');

      await _refreshAddressesFromSupabase(userId);
      debugPrint(
        '   Addresses refreshed. Total: ${_currentUser?.addresses.length}',
      );
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Error adding address: $e');
      debugPrint('   Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> updateAddress(
    String addressId,
    app_models.Address updatedAddress,
  ) async {
    if (_currentUser == null) {
      debugPrint('❌ Cannot update address: No current user');
      return false;
    }

    try {
      final supabase = Supabase.instance.client;
      final userId = _currentUser!.id;

      debugPrint('📝 Updating address: $addressId');
      debugPrint('   Title: ${updatedAddress.title}');

      if (updatedAddress.isDefault) {
        debugPrint('   Setting as default address...');
        await supabase
            .from('addresses')
            .update({'is_default': false})
            .eq('user_id', userId);
      }

      final data = _addressToSupabase(updatedAddress, userId);
      data.remove('user_id'); // prevent changing ownership

      final response = await supabase
          .from('addresses')
          .update(data)
          .eq('id', addressId)
          .eq('user_id', userId)
          .select();

      debugPrint('✅ Address updated successfully: $response');
      await _refreshAddressesFromSupabase(userId);
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Error updating address: $e');
      debugPrint('   Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> deleteAddress(String addressId) async {
    if (_currentUser == null) {
      debugPrint('❌ Cannot delete address: No current user');
      return false;
    }

    try {
      final supabase = Supabase.instance.client;
      final userId = _currentUser!.id;

      debugPrint('🗑️ Deleting address: $addressId');
      await supabase
          .from('addresses')
          .delete()
          .eq('id', addressId)
          .eq('user_id', userId);

      debugPrint('✅ Address deleted successfully');
      await _refreshAddressesFromSupabase(userId);
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Error deleting address: $e');
      debugPrint('   Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> setDefaultAddress(String addressId) async {
    if (_currentUser == null) return false;

    try {
      final supabase = Supabase.instance.client;
      final userId = _currentUser!.id;

      await supabase
          .from('addresses')
          .update({'is_default': false})
          .eq('user_id', userId);

      await supabase
          .from('addresses')
          .update({'is_default': true})
          .eq('id', addressId)
          .eq('user_id', userId);

      await _refreshAddressesFromSupabase(userId);
      return true;
    } catch (e) {
      print('Error setting default address: $e');
      return false;
    }
  }

  /// Fetch orders from database
  Future<void> fetchOrdersFromDatabase() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in, cannot fetch orders');
        return;
      }

      final ordersResponse = await _supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('user_id', user.id)
          .order('order_date', ascending: false);

      _orders.clear();
      for (var orderData in ordersResponse) {
        // Parse order items
        final items = (orderData['order_items'] as List)
            .map(
              (item) => app_models.OrderItem(
                id: item['id'].toString(),
                productId: item['product_id'].toString(),
                productName: item['product_name'].toString(),
                productImage: item['product_image'].toString(),
                price: (item['price'] as num).toDouble(),
                quantity: item['quantity'] as int,
              ),
            )
            .toList();

        // Get shipping address if available
        app_models.Address? shippingAddress;
        if (orderData['shipping_address_id'] != null) {
          final addressData = await _supabase
              .from('addresses')
              .select()
              .eq('id', orderData['shipping_address_id'])
              .maybeSingle();

          if (addressData != null) {
            shippingAddress = _addressFromSupabase(addressData);
          }
        }

        // Create default address if none found
        shippingAddress ??= app_models.Address(
          id: '',
          title: 'No Address',
          fullAddress: '',
          latitude: 0.0,
          longitude: 0.0,
          city: '',
          state: '',
          zipCode: '',
          country: '',
        );

        final order = app_models.Order(
          id: orderData['id'].toString(),
          orderNumber: orderData['order_number'].toString(),
          items: items,
          totalAmount: (orderData['total_amount'] as num).toDouble(),
          status: app_models.OrderStatus.values.firstWhere(
            (e) => e.name == orderData['status'],
            orElse: () => app_models.OrderStatus.pending,
          ),
          shippingAddress: shippingAddress,
          orderDate: DateTime.parse(orderData['order_date']),
          deliveryDate: orderData['delivery_date'] != null
              ? DateTime.parse(orderData['delivery_date'])
              : null,
          trackingNumber: orderData['tracking_number'],
        );

        _orders.add(order);
      }

      debugPrint('Fetched ${_orders.length} orders from database');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching orders from database: $e');
    }
  }

  Future<String> createOrder(app_models.Order order) async {
    // Note: Order creation is now handled by CheckoutService
    // This method is kept for backward compatibility
    final orderNumber =
        'NEX-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch}';
    return orderNumber;
  }

  Future<bool> updateOrderStatus(
    String orderId,
    app_models.OrderStatus newStatus,
  ) async {
    // Note: Order status updates are now handled by CheckoutService
    // This method is kept for backward compatibility
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) return false;

      await supabase
          .from('orders')
          .update({'status': newStatus.name})
          .eq('id', orderId)
          .eq('user_id', user.id);

      // Refresh orders from database
      await fetchOrdersFromDatabase();
      return true;
    } catch (e) {
      debugPrint('Error updating order status: $e');
      return false;
    }
  }

  app_models.Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  app_models.Order? getOrderByNumber(String orderNumber) {
    try {
      return _orders.firstWhere((order) => order.orderNumber == orderNumber);
    } catch (e) {
      return null;
    }
  }

  List<app_models.Order> getOrdersByStatus(app_models.OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  /// Refresh orders from database
  Future<void> refreshOrders() async {
    await fetchOrdersFromDatabase();
  }

  // API Integration Methods

  // Login with API
  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.authEndpoint}/login',
        body: {'email': email, 'password': password},
      );

      if (response['success'] == true) {
        _authToken = response['token'];
        _currentUser = app_models.User.fromJson(response['user']);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Register with API
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.authEndpoint}/register',
        body: {'name': name, 'email': email, 'password': password},
      );

      if (response['success'] == true) {
        _authToken = response['token'];
        _currentUser = app_models.User.fromJson(response['user']);
        return true;
      }
      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  // Fetch user profile from API
  Future<bool> fetchUserProfile() async {
    if (_authToken == null) return false;

    try {
      final response = await _apiService.get(
        '${ApiConfig.usersEndpoint}/profile',
        token: _authToken!,
      );

      if (response['success'] == true) {
        _currentUser = app_models.User.fromJson(response['user']);
        return true;
      }
      return false;
    } catch (e) {
      print('Fetch profile error: $e');
      return false;
    }
  }

  // Fetch orders from API
  Future<bool> fetchOrders() async {
    if (_authToken == null) return false;

    try {
      final response = await _apiService.get(
        ApiConfig.ordersEndpoint,
        token: _authToken!,
      );

      if (response['success'] == true) {
        _orders = (response['orders'] as List)
            .map((orderJson) => app_models.Order.fromJson(orderJson))
            .toList();
        return true;
      }
      return false;
    } catch (e) {
      print('Fetch orders error: $e');
      return false;
    }
  }

  // Update user profile via API
  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    if (_authToken == null || _currentUser == null) return false;

    try {
      final response = await _apiService.put(
        '${ApiConfig.usersEndpoint}/profile',
        body: updates,
        token: _authToken!,
      );

      if (response['success'] == true) {
        _currentUser = app_models.User.fromJson(response['user']);
        return true;
      }
      return false;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    _authToken = null;
    _orders.clear();

    // Clear cart and favorites
    CartService().clearLocalState();
    FavoriteService().clearLocalState();

    final supabase = Supabase.instance.client;
    await supabase.auth.signOut();
    notifyListeners();
  }

  // Set current user from User model
  void setCurrentUser(app_models.User user) {
    _currentUser = user;
    _authToken =
        'supabase_token'; // Placeholder, actual token handled by Supabase
  }

  // Set current user from Supabase User
  Future<void> setCurrentUserFromSupabase(gotrue.User supabaseUser) async {
    // First, ensure user record exists in public.users table
    await _ensureUserRecordExists(supabaseUser);

    // Get name from metadata - check both userMetadata and appMetadata
    final userMeta = _safeMetadata(supabaseUser.userMetadata);
    final appMeta = _safeMetadata(supabaseUser.appMetadata);

    final name =
        userMeta['name'] ??
        userMeta['full_name'] ??
        appMeta['name'] ??
        appMeta['full_name'] ??
        supabaseUser.email?.split('@')[0] ??
        '';

    print('Setting user from Supabase:');
    print('  Email: ${supabaseUser.email}');
    print('  User Metadata: $userMeta');
    print('  App Metadata: $appMeta');
    print('  Extracted Name: $name');

    // Get profile image - check multiple sources
    final profileImage =
        userMeta['avatar_url'] ??
        userMeta['profile_image'] ??
        userMeta['picture'] ??
        appMeta['avatar_url'] ??
        appMeta['profile_image'] ??
        appMeta['picture'] ??
        null;

    final addresses = await _fetchUserAddressesFromSupabase(supabaseUser.id);

    _currentUser = app_models.User(
      id: supabaseUser.id,
      name: name,
      email: supabaseUser.email ?? '',
      phone: supabaseUser.phone,
      profileImage: profileImage,
      addresses: addresses,
      orders: [],
      createdAt: supabaseUser.createdAt is DateTime
          ? supabaseUser.createdAt as DateTime
          : DateTime.now(),
      updatedAt: supabaseUser.updatedAt is DateTime
          ? supabaseUser.updatedAt as DateTime
          : DateTime.now(),
    );
    _authToken =
        'supabase_token'; // Placeholder, actual token handled by Supabase
    notifyListeners(); // Notify listeners of change

    // Refresh cart and favorites for the new user
    CartService().refreshCart();
    FavoriteService().refreshFavorites();
  }

  // Ensure user record exists in public.users table
  Future<void> _ensureUserRecordExists(gotrue.User supabaseUser) async {
    try {
      final supabase = Supabase.instance.client;

      // Get name from metadata
      final userMeta = _safeMetadata(supabaseUser.userMetadata);
      final appMeta = _safeMetadata(supabaseUser.appMetadata);
      final name =
          userMeta['name'] ??
          userMeta['full_name'] ??
          appMeta['name'] ??
          appMeta['full_name'] ??
          supabaseUser.email?.split('@')[0] ??
          'User';

      // Get profile image
      final profileImage =
          userMeta['avatar_url'] ??
          userMeta['profile_image'] ??
          userMeta['picture'] ??
          appMeta['avatar_url'] ??
          appMeta['profile_image'] ??
          appMeta['picture'] ??
          null;

      // Check if user is admin (by email)
      final isAdmin = supabaseUser.email == 'aliabouali2005@gmail.com';

      // Insert or update user record
      await supabase.from('users').upsert({
        'id': supabaseUser.id,
        'name': name,
        'phone': supabaseUser.phone,
        'profile_image': profileImage,
        'is_admin': isAdmin,
      });

      print('✅ User record ensured in public.users:');
      print('   ID: ${supabaseUser.id}');
      print('   Email: ${supabaseUser.email}');
      print('   Is Admin: $isAdmin');
    } catch (e) {
      print('⚠️ Error ensuring user record: $e');
      // Don't throw - continue anyway
    }
  }

  Map<String, dynamic> _safeMetadata(dynamic metadata) {
    if (metadata is Map<String, dynamic>) {
      return metadata;
    }
    return <String, dynamic>{};
  }

  Future<List<app_models.Address>> _fetchUserAddressesFromSupabase(
    String userId,
  ) async {
    try {
      debugPrint('📥 Fetching addresses for user: $userId');
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('addresses')
          .select()
          .eq('user_id', userId)
          .order('is_default', ascending: false)
          .order('created_at', ascending: true);

      final data = response as List<dynamic>;
      debugPrint('   Found ${data.length} addresses');

      final addresses = data
          .map<app_models.Address>(
            (item) => _addressFromSupabase(item as Map<String, dynamic>),
          )
          .toList();

      for (var addr in addresses) {
        debugPrint(
          '   - ${addr.title} (${addr.isDefault ? "DEFAULT" : ""}): ${addr.fullAddress}',
        );
      }

      return addresses;
    } catch (e, stackTrace) {
      debugPrint('❌ Error fetching addresses: $e');
      debugPrint('   Stack trace: $stackTrace');
      return [];
    }
  }

  Future<void> _refreshAddressesFromSupabase(String userId) async {
    debugPrint('🔄 Refreshing addresses from database...');
    final addresses = await _fetchUserAddressesFromSupabase(userId);
    if (_currentUser != null && _currentUser!.id == userId) {
      _currentUser = _currentUser!.copyWith(
        addresses: addresses,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
      debugPrint('✅ Addresses refreshed and listeners notified');
    }
  }

  Map<String, dynamic> _addressToSupabase(
    app_models.Address address,
    String userId,
  ) {
    final data = {
      'user_id': userId,
      'title': address.title,
      'full_address': address.fullAddress,
      'latitude': address.latitude,
      'longitude': address.longitude,
      'city': address.city,
      'state': address.state,
      'zip_code': address.zipCode,
      'country': address.country,
      'is_default': address.isDefault,
    };

    if (address.id.isNotEmpty) {
      data['id'] = address.id;
    }
    return data;
  }

  app_models.Address _addressFromSupabase(Map<String, dynamic> data) {
    return app_models.Address(
      id: data['id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      fullAddress: data['full_address']?.toString() ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      city: data['city']?.toString() ?? '',
      state: data['state']?.toString() ?? '',
      zipCode: data['zip_code']?.toString() ?? '',
      country: data['country']?.toString() ?? '',
      isDefault: data['is_default'] == true,
    );
  }

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null && _authToken != null;

  // Update profile image
  Future<bool> updateProfileImage(String imageUrl) async {
    if (_currentUser == null) return false;

    try {
      // Update in Supabase user metadata
      final supabase = Supabase.instance.client;
      await supabase.auth.updateUser(
        UserAttributes(
          data: {'avatar_url': imageUrl, 'profile_image': imageUrl},
        ),
      );

      // Update local user
      _currentUser = _currentUser!.copyWith(
        profileImage: imageUrl,
        updatedAt: DateTime.now(),
      );

      // Refresh session
      await supabase.auth.refreshSession();

      // Update from Supabase to get latest data
      final supabaseUser = supabase.auth.currentUser;
      if (supabaseUser != null) {
        await setCurrentUserFromSupabase(supabaseUser);
      }

      return true;
    } catch (e) {
      print('Error updating profile image: $e');
      return false;
    }
  }

  // Upload image to Supabase Storage
  Future<String?> uploadProfileImage(String imagePath) async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) return null;

      // Read image file
      final imageFile = File(imagePath);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '$userId/$fileName';

      // Upload to Supabase Storage
      await supabase.storage
          .from('avatars')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      // Get public URL
      final imageUrl = supabase.storage.from('avatars').getPublicUrl(filePath);

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      // If storage bucket doesn't exist, we'll store the image path in metadata
      // For now, return the local path as fallback
      return imagePath;
    }
  }
}
