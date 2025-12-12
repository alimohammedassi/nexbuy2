// This file shows examples of how to use your API integration
// You can delete this file after understanding the examples

import '../services/user_service.dart';
import '../services/product_service.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class ApiUsageExamples {
  final UserService _userService = UserService();
  final ProductService _productService = ProductService();
  final ApiService _apiService = ApiService();

  // Example 1: User Login
  Future<void> loginExample() async {
    try {
      bool success = await _userService.login(
        'user@example.com',
        'password123',
      );

      if (success) {
        print('Login successful!');
        print('User: ${_userService.currentUser?.name}');
        print('Token: ${_userService.authToken}');
      } else {
        print('Login failed!');
      }
    } catch (e) {
      print('Login error: $e');
    }
  }

  // Example 2: User Registration
  Future<void> registerExample() async {
    try {
      bool success = await _userService.register(
        'John Doe',
        'john@example.com',
        'password123',
      );

      if (success) {
        print('Registration successful!');
      } else {
        print('Registration failed!');
      }
    } catch (e) {
      print('Registration error: $e');
    }
  }

  // Example 3: Fetch Products
  Future<void> fetchProductsExample() async {
    try {
      bool success = await _productService.fetchProducts();

      if (success) {
        print('Products loaded: ${_productService.products.length}');
        for (var product in _productService.products) {
          print('- ${product.name}: \$${product.price}');
        }
      } else {
        print('Failed to load products');
      }
    } catch (e) {
      print('Fetch products error: $e');
    }
  }

  // Example 4: Direct API Call
  Future<void> directApiCallExample() async {
    try {
      // Get all products
      var response = await _apiService.get('/products');
      print('API Response: $response');

      // Post data
      var postResponse = await _apiService.post(
        '/orders',
        body: {'productId': '123', 'quantity': 2, 'total': 99.99},
      );
      print('Post Response: $postResponse');
    } catch (e) {
      print('Direct API call error: $e');
    }
  }

  // Example 5: Using API Configuration
  void showApiConfig() {
    print('Base URL: ${ApiConfig.baseUrl}');
    print('API Base URL: ${ApiConfig.apiBaseUrl}');
    print('Login URL: ${ApiConfig.loginUrl}');
    print('Products URL: ${ApiConfig.productsUrl}');
    print('Orders URL: ${ApiConfig.ordersUrl}');
  }
}

// How to use in your widgets:
/*
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final UserService _userService = UserService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    
    try {
      // Check if user is logged in
      if (_userService.isLoggedIn) {
        // Fetch fresh data from API
        await _userService.fetchUserProfile();
        await _userService.fetchOrders();
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    }
    
    return Text('Welcome ${_userService.currentUser?.name}');
  }
}
*/
