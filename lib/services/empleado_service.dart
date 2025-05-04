import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/empleado.dart';

class EmpleadoService {
  static const String baseUrl = 'http://localhost:3000/api/colaboradores';

  static Future<List<Empleado>> getEmpleados() async {
  try {
    final response = await http.get(Uri.parse(baseUrl));
    print('Código de respuesta: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Empleado.fromJson(e)).toList();
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      return [];
    }
  } catch (e) {
    print('Excepción al cargar empleados: $e');
    return [];
  }
}

static Future<bool> crearEmpleado(Map<String, dynamic> data) async {
  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    print('Respuesta POST: ${response.statusCode}');
    print('Body: ${response.body}');

    return response.statusCode == 201 || response.statusCode == 200;
  } catch (e) {
    print('Excepción al crear empleado: $e');
    return false;
  }
}


  static Future<bool> actualizarEmpleado(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  static Future<bool> eliminarEmpleado(String id) async {
  final response = await http.delete(Uri.parse('$baseUrl/$id'));
  return response.statusCode == 200;
}
}
