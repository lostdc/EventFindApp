import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'dart:async';

import 'package:event_find/models/map_marker.dart';

const mapboxAccessToken = 'pk.eyJ1IjoiamRvbWluZ3VlejI1IiwiYSI6ImNsZnUzOG5odzA2dWozZG80eWg3dDJsYWoifQ.Yw-vXDw2_voeUEBga0HiZA';

LatLng myPosition = LatLng(-29.952047, -71.3502365);

class MapScreeen extends StatefulWidget {
  const MapScreeen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreeen> {
  final Location locationController = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _requestLocationPermissionAndGetLocation();

    _locationSubscription = locationController.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        myPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    });

    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    List<MapMarker> mapMarkers = await fetchMapMarkers();
    setState(() {
      _markers = _buildMarkers(mapMarkers);
    });
  }

List<Marker> _buildMarkers(List<MapMarker> markers) {
  return markers.map((marker) {
    return Marker(
      point: marker.location!,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            // Aquí se muestra la información del marcador al hacer clic en él
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(marker.titulo ?? ''),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("${marker.imagen}"),
                      const SizedBox(height: 10),
                      Text(marker.detalleEvento ?? ''),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cerrar'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40,
          ),
        );
      },
    );
  }).toList();
}

  

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _requestLocationPermissionAndGetLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await locationController.getLocation();
    setState(() {
      myPosition = LatLng(locationData.latitude!, locationData.longitude!);
    });
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
            markers: [
              Marker(
                point: myPosition,
                builder: (context) {
                  return const Icon(
                    Icons.person_pin,
                    color: Colors.blueAccent,
                    size: 40,
                  );
                },
              ),
              ..._markers,
            ],
          )
        ],
      ),


      
    );
  }
}
