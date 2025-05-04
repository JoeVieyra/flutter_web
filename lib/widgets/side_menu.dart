import 'package:flutter/material.dart';
import 'package:flutter_web/screens/colaborador_form_screen.dart';
import 'package:flutter_web/screens/file_upload_screen.dart';
import 'package:flutter_web/screens/services_screen.dart';

class SideMenu extends StatelessWidget {
  final Function(Widget) onSelect;

  const SideMenu({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text('Menú'),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text('Carga de Archivos'),
            onTap: () {
              Navigator.pop(context);
              onSelect(FileUploadScreen());
            },
          ),
          ListTile(
            title: Text('Colaborador'),
            onTap: () {
              Navigator.pop(context);
              onSelect(ColaboradorFormScreen());
            },
          ),
          ListTile(
            title: Text('Empleados'),
            onTap: () {
              Navigator.pop(context);
              //onSelect(EmployeesScreen());
            },
          ),
          ListTile(
            title: Text('Servicios'),
            onTap: () {
              Navigator.pop(context);
              onSelect(ServicesScreen());
            },
          ),
        ],
      ),
    );
  }
}
