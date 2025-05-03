import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  final List<Map<String, String>> _archivos = [];

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'xlsx'],
    );

    if (result != null && result.files.single.name.isNotEmpty) {
      final archivo = result.files.single;

      final extension = archivo.extension ?? 'desconocido';
      final nombre = archivo.name;
      final fecha = DateFormat('dd/MM/yyyy – HH:mm').format(DateTime.now());

      setState(() {
        _archivos.add({
          'nombre': nombre,
          'extension': extension,
          'fecha': fecha,
        });
      });

      // Aquí puedes hacer POST al backend si lo necesitas
      // await FileService.uploadFileData(nombre, extension, fecha);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carga de Archivos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.upload_file),
              label: Text('Seleccionar archivo'),
              onPressed: _pickFile,
            ),
            SizedBox(height: 24),
            Expanded(
              child: _archivos.isEmpty
                  ? Center(child: Text('No hay archivos cargados.'))
                  : DataTable(
                      columns: const [
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Extensión')),
                        DataColumn(label: Text('Fecha de carga')),
                      ],
                      rows: _archivos
                          .map(
                            (archivo) => DataRow(cells: [
                              DataCell(Text(archivo['nombre']!)),
                              DataCell(Text(archivo['extension']!)),
                              DataCell(Text(archivo['fecha']!)),
                            ]),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
