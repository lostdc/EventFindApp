import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:event_find/models/map_marker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

const mapboxAccessToken = 'pk.eyJ1IjoiamRvbWluZ3VlejI1IiwiYSI6ImNsZnUzOG5odzA2dWozZG80eWg3dDJsYWoifQ.Yw-vXDw2_voeUEBga0HiZA';

LatLng myPosition = LatLng(-29.952047, -71.3502365);

class MapScreeen extends StatefulWidget {

  final String profilePictureUrl;
  const MapScreeen({Key? key, required this.profilePictureUrl}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreeen> {
  final Location locationController = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  List<Marker> _markers = [];

  // Agrega el Completer para manejar el estado de la construcción del mapa
  final Completer<void> _mapCompleter = Completer<void>();
  final MapController   mapController = MapController();


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

  void _moveToLatLng(LatLng newLatLng) {
    mapController.move(newLatLng, mapController.zoom);
  }

  Future<void> _loadMarkers() async {
    List<MapMarker> mapMarkers = await fetchMapMarkers();
    setState(() {
      _markers = _buildMarkers(mapMarkers);
    });
  }

List<Marker> _buildMarkers(List<MapMarker> markers) {
  return markers.map((marker) {
    //String newImagePath = marker.imagen!.replaceAll(
    //    'assets/eventos/05-04-2023/images/eventos_4_iv_region_de_coquimbo/',
    //    'event_find/eventos/passline/imagenes/eventos_4_iv_region_de_coquimbo/');
    String newImagePath;
    if(marker.logo == 'logo_passline.png'){
      newImagePath = marker.imagen!.replaceAll(
          RegExp(r'assets/eventos/.+/images/'),
          'event_find/eventos/passline/imagenes/');
    }else{
      newImagePath = marker.imagen!.replaceAll(
          RegExp(r'assets/eventos/.+/images/'),
          'event_find/eventos/ticketplus/imagenes/');
    }


    String imageUrl;
    if (newImagePath.isNotEmpty) {
      imageUrl =
          'https://firebasestorage.googleapis.com/v0/b/eventfind-ad0e3.appspot.com/o/${Uri.encodeComponent(newImagePath)}?alt=media';
    } else {
      imageUrl =
          'https://via.placeholder.com/500.jpg?text=Image+missing';
    }
    

    String titulo = marker.titulo ?? '';
    String fecha = marker.fecha ?? '';
    String tituloConFecha = '$titulo - $fecha';

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
                  title: Text(tituloConFecha),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        const SizedBox(height: 10),
                        Text(marker.detalleEvento ?? ''),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            if (await canLaunchUrl(Uri.parse(marker.eventoUrl ?? ''))) {
                              await launchUrl(Uri.parse(marker.eventoUrl ?? ''));
                            } else {
                              throw 'Could not launch ${marker.eventoUrl}';
                            }
                          },
                          child: Text(
                            marker.eventoUrl ?? '',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: const Offset(-15, -8), // Ajusta los valores para mover el marcador en los ejes X e Y
                child: const SizedBox(
                  width: 100, // Ajusta el ancho del área de toque aquí
                  height: 100, // Ajusta el alto del área de toque aquí
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 60, // Aumentamos el tamaño del ícono aquí
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, 0), // Ajustamos el centrado del círculo aquí
                child: Container(
                  width: 100, // Aumentamos el tamaño del círculo aquí
                  height: 100, // Aumentamos el tamaño del círculo aquí
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/${marker.logo}', // Reemplaza esto con la ruta de tu logo en la carpeta assets
                      width: 65, // Aumentamos el tamaño del logo aquí
                      height: 65, // Aumentamos el tamaño del logo aquí
                    ),
                  ),
                ),
              ),
            ],
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

      // Completa el _mapCompleter una vez que se haya movido el mapa
      if (!_mapCompleter.isCompleted) {
        _mapCompleter.complete();        
      }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _mapCompleter.future,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FlutterMap(
              options: MapOptions(center: myPosition, minZoom: 12, maxZoom: 20, zoom: 18),
              mapController: mapController, // Agrega el controlador del mapa aquí
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
                        return GestureDetector(
                          onTap: () {
                            // Aquí se puede agregar la acción al hacer clic en el marcador azul
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              //const Icon(
                              //  Icons.person_pin,
                              //  color: Colors.blueAccent,
                              //  size: 40,
                              //),
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
                                    child: Image.network(
                                      widget.profilePictureUrl,
                                      fit: BoxFit.cover,
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
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      // Opcional: Agrega un botón flotante para mover el mapa a otra posición
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



  


