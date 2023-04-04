import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';


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

Future<String> fetchJSONFromStorage() async {
  FirebaseStorage storage = FirebaseStorage.instance;
  // Asegúrate de reemplazar esta ruta con la ruta de tu archivo en Firebase Storage
  String firebaseStoragePath = 'event_find/eventos/passline/eventos_4_iv_region_de_coquimbo.json';
  String jsonContent;

  try {
    final result = await storage.ref(firebaseStoragePath).getData();
    jsonContent = String.fromCharCodes(result as Iterable<int>);
  } catch (e) {
    print('Error al descargar el archivo JSON: $e');
    throw e;
  }

  return jsonContent;
}

Future<List<MapMarker>> fetchMapMarkers() async {
  // Leer el archivo como bytes
  ByteData byteData = await rootBundle.load('assets/eventos/30-03-2023/eventos_4_iv_region_de_coquimbo.json');

  // Decodificar los bytes a una cadena UTF-8
  String jsonString = utf8.decode(byteData.buffer.asUint8List());

  List<dynamic> jsonResponse = json.decode(jsonString);
  return jsonResponse.map((markerJson) => MapMarker.fromJson(markerJson)).toList();
}

//Future<List<MapMarker>> fetchMapMarkers() async {
//  String jsonString = await rootBundle.loadString('assets/eventos/30-03-2023/eventos_4_iv_region_de_coquimbo.json');
//  List<dynamic> jsonResponse = json.decode(jsonString);
//  return jsonResponse.map((markerJson) => MapMarker.fromJson(markerJson)).toList();
//}
