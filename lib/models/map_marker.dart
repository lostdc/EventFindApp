import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';


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

    //LatLng location = json['lat'] != null && json['long'] != null ? LatLng(json['lat'], json['long']) : LatLng(0, 0);
    LatLng location;
    if (json['lat'] != null && json['long'] != null) {
      double lat = double.tryParse(json['lat'].toString()) ?? 0.0;
      double long = double.tryParse(json['long'].toString()) ?? 0.0;
      location = LatLng(lat, long);
    } else {
      location = LatLng(0, 0);
    }

    return MapMarker(
      titulo: json['titulo'],
      fecha: json['fecha'],
      hora: json['hora'],
      direccionTitulo: json['direccionTitulo'],
      direccionDetalle: json['direccionDetalle'],
      detalleEvento: json['detalleEvento'],
      imagen: json['imagen'],
      eventoUrl: json['evento_url'],
      logo: json['logo'],
      location: location,
    );
  }
}

Future<String> fetchCombinedJsonFromStorage() async {
  FirebaseStorage storage = FirebaseStorage.instance;
  String firebaseStoragePathPassline = 'event_find/eventos/passline';
  String firebaseStoragePathTicketPlus = 'event_find/eventos/ticketplus';
  List<dynamic> combinedJsonData = [];

  try {
    // Obtén una lista de todos los archivos JSON en el directorio
    ListResult listResult = await storage.ref(firebaseStoragePathPassline).list();
    List<Reference> jsonRefs = listResult.items.where((ref) => ref.name.endsWith('.json')).toList();

    // Descarga el contenido de cada archivo JSON y añádelo al array combinado
    for (Reference jsonRef in jsonRefs) {
      final result = await jsonRef.getData();
      String jsonContent = String.fromCharCodes(result as Iterable<int>);
      List<dynamic> jsonData = jsonDecode(utf8.decode(jsonContent.codeUnits));

      // Agrega la propiedad 'logo' a cada objeto JSON
      for (var jsonObject in jsonData) {
        jsonObject['logo'] = 'logo_passline.png';
      }
      combinedJsonData.addAll(jsonData);
    }

    //codigo para agregar ticktplus
    ListResult listResult2 = await storage.ref(firebaseStoragePathTicketPlus).list();
    List<Reference> jsonRefs2 = listResult2.items.where((ref) => ref.name.endsWith('.json')).toList();

    // Descarga el contenido de cada archivo JSON y añádelo al array combinado
    for (Reference jsonRef in jsonRefs2) {
      final result = await jsonRef.getData();
      String jsonContent = String.fromCharCodes(result as Iterable<int>);
      List<dynamic> jsonData = jsonDecode(utf8.decode(jsonContent.codeUnits));

      combinedJsonData.addAll(jsonData);
    }
  } catch (e) {
    print('Error al descargar los archivos JSON: $e');
    throw e;
  }

  // Convierte el array combinado en un JSON en forma de String
  String combinedJsonContent = jsonEncode(combinedJsonData);
  return combinedJsonContent;
}



Future<List<MapMarker>> fetchMapMarkers() async {
 
  String jsonString = await fetchCombinedJsonFromStorage();
  List<dynamic> jsonResponse = json.decode(jsonString);

  return jsonResponse.map((markerJson) => MapMarker.fromJson(markerJson)).toList();
}

//Future<List<MapMarker>> fetchMapMarkers() async {
//  String jsonString = await rootBundle.loadString('assets/eventos/30-03-2023/eventos_4_iv_region_de_coquimbo.json');
//  List<dynamic> jsonResponse = json.decode(jsonString);
//  return jsonResponse.map((markerJson) => MapMarker.fromJson(markerJson)).toList();
//}
