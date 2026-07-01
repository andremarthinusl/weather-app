import 'package:equatable/equatable.dart';

class Place extends Equatable {
  const Place({
    required this.id,
    required this.name,
    required this.rating,
    required this.address,
    required this.isOpen,
    required this.photoUrl,
    required this.lat,
    required this.lng,
  });

  final String id;
  final String name;
  final double rating;
  final String address;
  final bool isOpen;
  final String? photoUrl;
  final double lat;
  final double lng;

  factory Place.fromJson(Map<String, dynamic> json) {
    String? photoUrl;
    if (json['photos'] != null && (json['photos'] as List).isNotEmpty) {
      final photoRef = json['photos'][0]['photo_reference'];
      photoUrl = photoRef; 
    } else if (json['photoUrl'] != null) {
      photoUrl = json['photoUrl']; // for mock data or nominatim wrapper
    }

    // Handle lat/lon parsing for both Google (double) and Nominatim (String)
    double parsedLat = 0.0;
    if (json['lat'] != null) {
      parsedLat = json['lat'] is String ? double.parse(json['lat']) : (json['lat'] as num).toDouble();
    } else if (json['geometry']?['location']?['lat'] != null) {
      parsedLat = (json['geometry']['location']['lat'] as num).toDouble();
    }

    double parsedLng = 0.0;
    if (json['lon'] != null) {
      parsedLng = json['lon'] is String ? double.parse(json['lon']) : (json['lon'] as num).toDouble();
    } else if (json['lng'] != null) {
      parsedLng = json['lng'] is String ? double.parse(json['lng']) : (json['lng'] as num).toDouble();
    } else if (json['geometry']?['location']?['lng'] != null) {
      parsedLng = (json['geometry']['location']['lng'] as num).toDouble();
    }

    return Place(
      id: json['place_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] as String? ?? 'Unknown Place',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      address: json['display_name'] as String? ?? json['vicinity'] as String? ?? json['address'] as String? ?? '',
      isOpen: json['opening_hours']?['open_now'] as bool? ?? json['isOpen'] as bool? ?? true,
      photoUrl: photoUrl,
      lat: parsedLat,
      lng: parsedLng,
    );
  }

  @override
  List<Object?> get props => [id, name, rating, address, isOpen, photoUrl, lat, lng];
}
