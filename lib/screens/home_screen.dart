import 'package:flutter/material.dart';
import 'package:flutter_web/screens/colaborador_form_screen.dart';
import 'package:flutter_web/screens/empleado_screen.dart';
import 'package:flutter_web/screens/file_upload_screen.dart';
import 'package:flutter_web/screens/services_screen.dart';

class HomeScreen extends StatelessWidget {
  final String nombre;
  final String rfc;
  final String email;

  const HomeScreen({
    super.key,
    required this.nombre,
    required this.rfc,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final fechaHora = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(title: const Text('Menú Principal')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.account_circle, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text('Bienvenido:', style: TextStyle(color: Colors.white, fontSize: 14)),
                  Text(nombre, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Carga de Archivos'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FileUploadScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('Colaboradores'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ColaboradorFormScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Empleados'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmpleadosScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.miscellaneous_services),
              title: const Text('Servicios'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen())),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Hola, $nombre 👋',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.badge),
                    title: const Text('RFC'),
                    subtitle: Text(rfc),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Correo electrónico'),
                    subtitle: Text(email),
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Sesión iniciada'),
                    subtitle: Text(fechaHora),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selecciona una opción en el menú lateral para comenzar.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

