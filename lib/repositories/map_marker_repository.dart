import 'dart:convert';
import 'package:event_find/models/map_marker.dart';
import 'package:event_find/services/firebase_storage_service.dart';

class MapMarkerRepository {
  final FirebaseStorageService _firebaseStorageService;

  MapMarkerRepository(this._firebaseStorageService);

  Future<List<MapMarker>> fetchMapMarkers() async {
    String jsonString = await _firebaseStorageService.fetchCombinedJsonFromStorage();
    List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((markerJson) => MapMarker.fromJson(markerJson)).toList();
  }
}
