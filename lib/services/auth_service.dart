import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://localhost:3000/api/auth";

  static Future<bool> registerUser({
    required String nombre,
    required String email,
    required String rfc,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'email': email,
        'rfc': rfc,
        'password': password,
        'confirmPassword': confirmPassword,
      }),
    );

    return response.statusCode == 201;
  }

 static Future<Map<String, dynamic>> loginUser({
  required String email,
  required String password,
  required String nombre,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'nombre':nombre, 'email': email, 'password': password}),
  );

  print("Status: ${response.statusCode}");
  print("Body: ${response.body}");


  Future<bool> changePassword(String email, String rfc, String newPassword) async {
  final response = await http.post(
    Uri.parse('$baseUrl/change-password'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'rfc': rfc, 'newPassword': newPassword}),
  );
  return response.statusCode == 200;
}

  try {
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'nombre': data['nombre'],
        'message': data['message'],
        'userId': data['userId'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Error desconocido',
      };
    }
  } catch (e) {
    print("Error en jsonDecode: $e");
    return {
      'success': false,
      'message': 'Respuesta del servidor no es JSON válido',
    };
  }
}
}