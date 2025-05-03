import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/services/file_service.dart';
import 'package:intl/intl.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  final List<Map<String, String>> _archivos = [];

  @override
  void initState() {
    super.initState();
    _loadFiles(); // <- Aquí se llama para cargar archivos al iniciar la pantalla
  }

  Future<void> _loadFiles() async {
    try {
      final files = await FileService.fetchUploadedFiles();
      setState(() {
        _archivos.clear();
        _archivos.addAll(
          files.map((archivo) => {
            'nombre': archivo['nombre'],
            'extension': archivo['extension'],
            'fecha': archivo['fechaCreacion'] != null
            ? DateFormat('dd/MM/yyyy – HH:mm').format(DateTime.parse(archivo['fechaCreacion']))
             : 'Sin fecha',
          }),
        );
      });
    } catch (e) {
      print('Error al cargar archivos: $e');
    }
  }



  Future<void> _pickFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'xlsx'],
  );

  if (result != null && result.files.single.bytes != null) {
    final archivo = result.files.single;

    final success = await FileService.uploadFile(archivo);

    if (success) {
      print('Archivo subido con éxito');
      // Aquí puedes actualizar tu UI si es necesario
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir archivo')),
      );
    }
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