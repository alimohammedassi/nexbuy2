class ApiConfig {
  // Base URL from your backend team
  static const String baseUrl = 'https://ec4611c2fe87.ngrok-free.app';

  // API endpoints
  static const String apiVersion = '/api/v1';

  // Full API base URL
  static String get apiBaseUrl => '$baseUrl$apiVersion';

  // Common endpoints
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String productsEndpoint = '/products';
  static const String ordersEndpoint = '/orders';
  static const String cartEndpoint = '/cart';

  // Full endpoint URLs
  static String get loginUrl => '$apiBaseUrl$authEndpoint/login';
  static String get registerUrl => '$apiBaseUrl$authEndpoint/register';
  static String get productsUrl => '$apiBaseUrl$productsEndpoint';
  static String get ordersUrl => '$apiBaseUrl$ordersEndpoint';
  static String get cartUrl => '$apiBaseUrl$cartEndpoint';

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true', // For ngrok URLs
  };

  // Auth headers (when user is logged in)
  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
