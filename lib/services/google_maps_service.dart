import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapsService {
  static const String _apiKey = 'AIzaSyBh6MwJ7XtWxaMxEVRaFGoKZmo3xQlRw5M';

  static String get apiKey => _apiKey;

  /// Get current user location
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// Convert Position to LatLng
  static LatLng positionToLatLng(Position position) {
    return LatLng(position.latitude, position.longitude);
  }

  /// Get address from coordinates using reverse geocoding
  static Future<String?> getAddressFromCoordinates(LatLng coordinates) async {
    try {
      // This would typically use Google Geocoding API
      // For now, return a placeholder
      return 'Address at ${coordinates.latitude.toStringAsFixed(4)}, ${coordinates.longitude.toStringAsFixed(4)}';
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }

  /// Search for places using Google Places API
  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    try {
      // This would use Google Places API
      // For now, return mock data
      return [
        {
          'name': 'Sample Address 1',
          'address': '123 Main Street, City',
          'lat': 24.7136,
          'lng': 46.6753,
        },
        {
          'name': 'Sample Address 2',
          'address': '456 Oak Avenue, City',
          'lat': 24.7200,
          'lng': 46.6800,
        },
      ];
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }
}
