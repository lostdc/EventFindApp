import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
class MapMarker {
  final String? titulo;
  final String? fecha;
  final String? hora;
  final String? logo;
  final String? direccionTitulo;
  final String? direccionDetalle;
  final String? detalleEvento;
  final String? imagen;
  final String? eventoUrl;
  final LatLng? location;

  MapMarker({
    required this.titulo,
    required this.fecha,
    required this.hora,
    required this.logo,
    required this.direccionTitulo,
    required this.direccionDetalle,
    required this.detalleEvento,
    required this.imagen,
    required this.eventoUrl,
    required this.location,
  });

  factory MapMarker.fromJson(Map<String, dynamic> json) {
    LatLng location;
    if (json['lat'] != null && json['long'] != null) {
      double lat  = double.tryParse(json['lat'].toString()) ?? 0.0;
      double long = double.tryParse(json['long'].toString()) ?? 0.0;
      location    = LatLng(lat, long);
    } else {
      location = LatLng(0, 0);
    }

    return MapMarker(
      titulo          : json['titulo'],
      fecha           : json['fecha'],
      hora            : json['hora'],
      direccionTitulo : json['direccionTitulo'],
      direccionDetalle: json['direccionDetalle'],
      detalleEvento   : json['detalleEvento'],
      imagen          : json['imagen'],
      eventoUrl       : json['evento_url'],
      logo            : json['logo'],
      location        : location,
    );
  }


  //estro me lo traje de la screen map_screen.dart
  static List<Marker> buildMarkers(List<MapMarker> markers) {
    return markers.map((marker) {
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
                            errorWidget: (context, url, error) => const Icon(Icons.error),
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
}
