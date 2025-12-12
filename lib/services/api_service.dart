import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // HTTP Client
  final http.Client _client = http.Client();

  // GET request
  Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse('${ApiConfig.apiBaseUrl}$endpoint');
      final headers = token != null
          ? ApiConfig.authHeaders(token)
          : ApiConfig.defaultHeaders;

      final response = await _client.get(url, headers: headers);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.apiBaseUrl}$endpoint');
      final headers = token != null
          ? ApiConfig.authHeaders(token)
          : ApiConfig.defaultHeaders;

      final response = await _client.post(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.apiBaseUrl}$endpoint');
      final headers = token != null
          ? ApiConfig.authHeaders(token)
          : ApiConfig.defaultHeaders;

      final response = await _client.put(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse('${ApiConfig.apiBaseUrl}$endpoint');
      final headers = token != null
          ? ApiConfig.authHeaders(token)
          : ApiConfig.defaultHeaders;

      final response = await _client.delete(url, headers: headers);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  // Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  // Dispose client
  void dispose() {
    _client.close();
  }
}
