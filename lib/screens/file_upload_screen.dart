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
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      final files = await FileService.fetchUploadedFiles();
      setState(() {
        _archivos.clear();
        _archivos.addAll(files.map((archivo) => {
              'nombre': archivo['nombre'],
              'extension': archivo['extension'],
              'fecha': archivo['fechaCreacion'] != null
                  ? DateFormat('dd/MM/yyyy – HH:mm').format(DateTime.parse(archivo['fechaCreacion']))
                  : 'Sin fecha',
            }));
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Archivo subido con éxito')),
        );
        _loadFiles(); // Refrescar la lista
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al subir archivo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carga de Archivos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    const Icon(Icons.upload_file, size: 28, color: Colors.blue),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text('Sube tus archivos PDF o Excel',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text('Seleccionar archivo'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _pickFile,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _archivos.isEmpty
                  ? const Center(child: Text('No hay archivos cargados.'))
                  : Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 32,
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
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
