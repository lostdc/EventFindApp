import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:event_find/models/map_marker.dart';

const mapboxAccessToken = 'pk.eyJ1IjoiamRvbWluZ3VlejI1IiwiYSI6ImNsZnUzOG5odzA2dWozZG80eWg3dDJsYWoifQ.Yw-vXDw2_voeUEBga0HiZA';

final myPosition = LatLng(-29.952047,-71.3502365);
class MapScreeen extends StatelessWidget {
  const MapScreeen({super.key});

    List<Marker> _buildMarkers(List<MapMarker> markers) {
    return markers.map((marker) {
      return Marker(
        point: marker.location!,
        builder: (context) {
          return const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40,
          );
        },
      );
    }).toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: FlutterMap(
        options: MapOptions(center: myPosition, minZoom: 5, maxZoom: 25, zoom: 18),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: const {
              'accessToken': mapboxAccessToken,
              'id': 'mapbox/streets-v12'
            },
          ),
        
          MarkerLayer(
           // markers: _buildMarkers(markers),
          )
        ],
      ),
    ); //Scaffold
  }
}