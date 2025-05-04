import 'package:flutter/material.dart';
import 'package:flutter_web/screens/colaborador_form_screen.dart';
import 'package:flutter_web/screens/empleado_screen.dart';
import 'package:flutter_web/screens/file_upload_screen.dart';
import 'package:flutter_web/screens/services_screen.dart';

class HomeScreen extends StatelessWidget {
  final String nombre;

  const HomeScreen({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menú Principal')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Bienvenido: $nombre'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text('Carga de Archivos'),
              onTap: () {
                 Navigator.push(
               context,
             MaterialPageRoute(builder: (_) => const FileUploadScreen()),
              );
              },
            ),
            ListTile(
              title: Text('Colaboradores'),
              onTap: () {Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ColaboradorFormScreen()),
            );},
            ),
            ListTile(
              title: Text('Empleados'),
              onTap: () {Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EmpleadosScreen()),
            );},
            ),
            ListTile(
              title: Text('Servicios'),
              onTap: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ServicesScreen()),
              );},
            ),
          ],
        ),
      ),
      body: Center(child: Text('Aquí va el contenido del dashboard')),
    );
  }
}
