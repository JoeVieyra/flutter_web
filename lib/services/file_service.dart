import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class FileService {
  static const String baseUrl = 'http://localhost:3000/api/files';

 static Future<bool> uploadFile(PlatformFile file) async {
    final uri = Uri.parse('$baseUrl/upload'); 

    try {
      // Crear una solicitud Multipart
      var request = http.MultipartRequest('POST', uri);
      

      // Añadir el archivo usando los bytes
      request.files.add(http.MultipartFile.fromBytes(
        'archivo', 
        file.bytes!,
        filename: file.name, // Nombre original del archivo
      ));

      // Enviar la solicitud
      var response = await request.send();

      if (response.statusCode == 201) {
        print('Archivo subido correctamente');
        return true;
      } else {
        print('Error al subir archivo: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción al subir archivo: $e');
      return false;
    }
  }

    
  

  static Future<List<Map<String, dynamic>>> fetchUploadedFiles() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener archivos');
    }
  }

}