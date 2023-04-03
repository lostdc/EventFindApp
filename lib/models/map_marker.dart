import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class MapMarker {
  final String? titulo;
  final String? fecha;
  final String? hora;
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
    required this.direccionTitulo,
    required this.direccionDetalle,
    required this.detalleEvento,
    required this.imagen,
    required this.eventoUrl,
    required this.location,
  });

  factory MapMarker.fromJson(Map<String, dynamic> json) {
    return MapMarker(
      titulo: json['titulo'],
      fecha: json['fecha'],
      hora: json['hora'],
      direccionTitulo: json['direccionTitulo'],
      direccionDetalle: json['direccionDetalle'],
      detalleEvento: json['detalleEvento'],
      imagen: json['imagen'],
      eventoUrl: json['evento_url'],
      location: LatLng(json['lat'], json['long']),
    );
  }
}

Future<List<MapMarker>> fetchMapMarkers() async {
  String jsonString = await rootBundle.loadString('assets/eventos/30-03-2023/eventos_4_iv_region_de_coquimbo.json');
  List<dynamic> jsonResponse = json.decode(jsonString);
  return jsonResponse.map((markerJson) => MapMarker.fromJson(markerJson)).toList();
}
