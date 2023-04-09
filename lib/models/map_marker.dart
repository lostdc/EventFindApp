import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:event_find/utils/marker_info_card_button.dart';

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
  static OverlayEntry? currentOverlayEntry;
  final Function(LatLng)? onMarkerTap;

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
    this.onMarkerTap, 
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



void _showOverlay(BuildContext context, String tituloConFecha, String? detalleEvento, String? eventoUrl, String imageUrl, PageController pageController, int index, List<MapMarker> mapMarkers, Function(int) onPageChanged) {
  OverlayState overlayState = Overlay.of(context)!;

  // Elimina el OverlayEntry actual antes de agregar uno nuevo
  if (MapMarker.currentOverlayEntry != null) {
    MapMarker.currentOverlayEntry!.remove();
  }

  OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
    return Positioned(
      bottom: 70,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: PageView(
                controller: pageController,
                onPageChanged: onPageChanged, // Añade el callback aquí
                children: mapMarkers.map((marker) {
                  String newImagePath;
                  if (marker.logo == 'logo_passline.png') {
                  newImagePath = marker.imagen!.replaceAll(
                      RegExp(r'assets/eventos/.+/images/'),
                      'event_find/eventos/passline/imagenes/',
                    );
                  } else {
                    newImagePath = marker.imagen!.replaceAll(
                      RegExp(r'assets/eventos/.+/images/'),
                      'event_find/eventos/ticketplus/imagenes/',
                    );
                  }
                  String imageUrl;
                  if (newImagePath.isNotEmpty) {
                    imageUrl =
                        'https://firebasestorage.googleapis.com/v0/b/eventfind-ad0e3.appspot.com/o/${Uri.encodeComponent(newImagePath)}?alt=media';
                  } else {
                    imageUrl =
                        'https://via.placeholder.com/500.jpg?text=Image+missing';
                  }
                  return MarkerInfoCardButton(
                    tituloConFecha: '${marker.titulo} ${marker.fecha}',
                    detalleEvento: marker.detalleEvento,
                    eventoUrl: marker.eventoUrl,
                    imageUrl: imageUrl,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  });

// Guarda el nuevo OverlayEntry como el actual
  MapMarker.currentOverlayEntry = overlayEntry;
  overlayState.insert(overlayEntry);
  // Asegurarse de que el OverlayEntry se muestre antes de llamar a jumpToPage
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    pageController.jumpToPage(index);
  });
}

  //estro me lo traje de la screen map_screen.dart
  static List<Marker> buildMarkers(List<MapMarker> markers, void Function(LatLng) moveToLatLngCallback, PageController pageController) {
    //return markers.map((marker) {
    //  String newImagePath;

    return markers.asMap().entries.map((entry) {
      int index = entry.key;
      MapMarker marker = entry.value;
      String newImagePath;

      if (marker.logo == 'logo_passline.png') {
        newImagePath = marker.imagen!.replaceAll(
            RegExp(r'assets/eventos/.+/images/'),
            'event_find/eventos/passline/imagenes/');
      } else {
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
              if (marker.location != null) {
                moveToLatLngCallback(marker.location!); // Asegúrate de utilizar el callback aquí
              }
               PageController pageController = PageController(initialPage: index);
               marker._showOverlay(
                context,
                tituloConFecha,
                marker.detalleEvento,
                marker.eventoUrl,
                imageUrl,
                pageController,
                index,
                markers,
                (int markerIndex) {
                  if (markerIndex >= 0 && markerIndex < markers.length) {
                    MapMarker marker = markers[markerIndex];
                    moveToLatLngCallback(marker.location!);
                  }
                }
              );
              //marker._showOverlay(context, tituloConFecha, marker.detalleEvento, marker.eventoUrl, imageUrl, pageController, index);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(-15, -8),
                  child: const SizedBox(
                    width: 100,
                    height: 100,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 60,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, 0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/${marker.logo}',
                        width: 65,
                        height: 65,
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
