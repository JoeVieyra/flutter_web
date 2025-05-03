import 'package:flutter/material.dart';
import 'package:flutter_web/screens/colaboradores_screen.dart';
import 'package:flutter_web/screens/file_upload_screen.dart';
import 'package:flutter_web/screens/services_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menú Principal')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Bienvenido, usuario: $userId'),
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
            MaterialPageRoute(builder: (_) => const ColaboradoresScreen()),
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
