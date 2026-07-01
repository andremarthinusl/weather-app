import '../api/places_api_client.dart';
import '../models/place.dart';

class PlacesRepository {
  PlacesRepository({PlacesApiClient? placesApiClient})
      : _placesApiClient = placesApiClient ?? PlacesApiClient();

  final PlacesApiClient _placesApiClient;

  Future<List<Place>> getRecommendations(String query, String cityName) async {
    return _placesApiClient.searchPlaces(query, cityName);
  }

  String getPhotoUrl(String photoReference) {
    return _placesApiClient.getPhotoUrl(photoReference);
  }

  void dispose() => _placesApiClient.close();
}
