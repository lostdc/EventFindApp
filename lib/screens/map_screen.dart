import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:event_find/models/map_marker.dart';
import 'package:event_find/repositories/map_marker_repository.dart';
import 'package:event_find/services/firebase_storage_service.dart';
import 'package:event_find/config/config.dart';
//import 'package:event_find/utils/location_utils.dart';

LatLng myPosition = LatLng(0,0);
class InteractiveMapScreen extends StatefulWidget {
  final String profilePictureUrl;
  const InteractiveMapScreen({Key? key, required this.profilePictureUrl}) : super(key: key);

  @override
  _InteractiveMapScreenState createState() => _InteractiveMapScreenState();
}
class _InteractiveMapScreenState extends State<InteractiveMapScreen> {

  late final FirebaseStorageService  firebaseStorageService;
  late final MapMarkerRepository mapMarkerRepository;
  late PageController pageController; // Añadir un PageController
  
  final Location locationController = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  List<Marker> _markers = [];
  // Agrega el Completer para manejar el estado de la construcción del mapa
  final Completer<void> _mapCompleter = Completer<void>();
  final MapController   mapController = MapController();

  @override
  void initState() {
    super.initState();
    firebaseStorageService  = FirebaseStorageService();
    mapMarkerRepository     = MapMarkerRepository(firebaseStorageService);
    pageController          = PageController(); // Inicializar el PageController


    _requestLocationPermissionAndGetLocation();
    _locationSubscription = locationController.onLocationChanged.listen((LocationData currentLocation) {
    setState(() {
        myPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    });
    _loadMarkers();
  }

  void _moveToLatLng(LatLng newLatLng) {
    mapController.move(newLatLng, mapController.zoom);
  }

  _loadMarkers() async {
    List<MapMarker> mapMarkers = await mapMarkerRepository.fetchMapMarkers();
    setState(() {
      _markers = MapMarker.buildMarkers(mapMarkers,_moveToLatLng); // Usa el método estático aquí
    });
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

      // Completa el _mapCompleter una vez que se haya movido el mapa
      if (!_mapCompleter.isCompleted) {
        _mapCompleter.complete();        
      }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: FutureBuilder(
        future: _mapCompleter.future,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FlutterMap(
              options: MapOptions(center: myPosition, minZoom: 12, maxZoom: 20, zoom: 12),
              mapController: mapController, // Agrega el controlador del mapa aquí
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: const {
                    'accessToken': Config.mapboxAccessToken,
                    'id': 'mapbox/streets-v12'
                  },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: myPosition,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            // Aquí se puede agregar la acción al hacer clic en el marcador azul
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.translate(
                                offset: const Offset(0, 0),
                                child: ClipOval(
                                  child: Container(
                                    width: 80, // Aumenta el tamaño de la foto de perfil aquí
                                    height: 80, // Aumenta el tamaño de la foto de perfil aquí
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.profilePictureUrl,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ..._markers,
                  ],
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Establece las coordenadas de latitud y longitud deseadas
          _moveToLatLng(myPosition);
        },
        child: const Icon(Icons.location_on),
      ),
    );
  }
}