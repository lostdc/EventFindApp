import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location.dart';
import '../environments/dev_config.dart';

class ApiService {
  // Coloca aquí la URL base de tu API
  static const String baseUrl = EnvironmentConfig.apiBaseUrl;

  // Método para obtener los datos desde la API
  Future<List<Location>> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/ruta-de-tu-api'));

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((location) => Location.fromJson(location)).toList();
    } else {
      throw Exception('Error al obtener datos desde la API');
    }
  }
}