import 'package:latlong2/latlong.dart';
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
}
