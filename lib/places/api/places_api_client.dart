import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';

class PlacesRequestFailure implements Exception {}

class PlacesApiClient {
  PlacesApiClient({http.Client? httpClient, this.apiKey = ''})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  final String apiKey;




  Future<List<Place>> searchPlaces(String query, String cityName) async {
    // Nominatim doesn't understand "OR" or complex terms like "Soto". 
    // We map it to generic amenity types: restaurant, cafe, or fast food.
    String osmq = 'restaurant';
    final lowerQ = query.toLowerCase();
    if (lowerQ.contains('cafe') || lowerQ.contains('coffee')) {
      osmq = 'cafe';
    } else if (lowerQ.contains('es krim') || lowerQ.contains('minuman') || lowerQ.contains('street food') || lowerQ.contains('angkringan')) {
      osmq = 'fast food';
    } else {
      osmq = 'restaurant';
    }
    
    final fullQuery = '$osmq in $cityName';

    // Use OpenStreetMap Nominatim API (100% Free, no API key required)
    final request = Uri.https(
      'nominatim.openstreetmap.org',
      '/search',
      {
        'q': fullQuery,
        'format': 'jsonv2',
        'limit': '5',
      },
    );

    // Provide user-agent as per Nominatim usage policy
    final response = await _httpClient.get(request, headers: {
      'User-Agent': 'WeatherApp/1.0 (StudentProject)',
    });

    if (response.statusCode != 200) {
      throw PlacesRequestFailure();
    }

    final List<dynamic> results = jsonDecode(response.body);
    
    // Process results and assign context-aware placeholder images
    return results.map((e) {
      final data = e as Map<String, dynamic>;
      // Nominatim does not provide photos, so we assign a contextual food image
      data['photoUrl'] = _getPhotoForQuery(query);
      data['rating'] = 4.0 + (data['place_id'] % 10) / 10; // Pseudo-random realistic rating 4.0 - 4.9
      return Place.fromJson(data);
    }).toList();
  }

  String _getPhotoForQuery(String q) {
    q = q.toLowerCase();
    if (q.contains('soto') || q.contains('bakso') || q.contains('ramen')) {
      return 'https://images.unsplash.com/photo-1548943487-a2e4f43bb285?w=400&q=80';
    } else if (q.contains('kopi') || q.contains('cafe')) {
      return 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400&q=80';
    } else if (q.contains('es krim') || q.contains('minuman')) {
      return 'https://images.unsplash.com/photo-1563805042-7684c8a9e9cb?w=400&q=80';
    } else if (q.contains('angkringan') || q.contains('street food')) {
      return 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400&q=80';
    }
    return 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&q=80'; // Default food
  }



  String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    if (apiKey.isEmpty || photoReference.startsWith('http')) return photoReference;
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&photo_reference=$photoReference&key=$apiKey';
  }

  void close() {
    _httpClient.close();
  }

}
