import 'package:flutter/material.dart';
import '../services/empleado_service.dart';
import '../models/empleado.dart';

class EmpleadosScreen extends StatefulWidget {
  const EmpleadosScreen({super.key});

  @override
  State<EmpleadosScreen> createState() => _EmpleadosScreenState();
}

class _EmpleadosScreenState extends State<EmpleadosScreen> {
  List<Empleado> empleados = [];
  List<Empleado> empleadosFiltrados = [];
  TextEditingController busquedaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarEmpleados();
  }

  Future<void> cargarEmpleados() async {
    final data = await EmpleadoService.getEmpleados();
    setState(() {
      empleados = data;
      empleadosFiltrados = data;
    });
  }

void confirmarEliminacion(Empleado empleado) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar empleado'),
        content: Text('¿Estás seguro de que deseas eliminar a ${empleado.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final eliminado = await EmpleadoService.eliminarEmpleado(empleado.id);
              if (eliminado) {
                await cargarEmpleados();
                Navigator.of(context).pop();
              }
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }



  void filtrarEmpleados(String query) {
    final resultado = empleados.where((empleado) {
      return empleado.nombre.toLowerCase().contains(query.toLowerCase()) ||
             empleado.curp.toLowerCase().contains(query.toLowerCase()) ||
             empleado.rfc.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      empleadosFiltrados = resultado;
    });
  }

  void mostrarDialogoEdicion(Empleado empleado) {
    final nombreController = TextEditingController(text: empleado.nombre);
    final curpController = TextEditingController(text: empleado.curp);
    final rfcController = TextEditingController(text: empleado.rfc);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Editar empleado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombreController, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: curpController, decoration: InputDecoration(labelText: 'CURP')),
            TextField(controller: rfcController, decoration: InputDecoration(labelText: 'RFC')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final actualizado = await EmpleadoService.actualizarEmpleado(
                empleado.id,
                {
                  'nombre': nombreController.text,
                  'curp': curpController.text,
                  'rfc': rfcController.text,
                },
              );
              if (actualizado) {
                await cargarEmpleados();
                Navigator.of(context).pop();
              }
            },
            child: Text('Guardar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empleados'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: busquedaController,
              onChanged: filtrarEmpleados,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, CURP o RFC',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: empleadosFiltrados.length,
        itemBuilder: (context, index) {
          final empleado = empleadosFiltrados[index];
          return ListTile(
            title: Text(empleado.nombre),
            subtitle: Text('CURP: ${empleado.curp} | RFC: ${empleado.rfc}'),
            trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => mostrarDialogoEdicion(empleado),
            ),
            IconButton(
      icon: Icon(Icons.delete),
      onPressed: () => confirmarEliminacion(empleado),
    ),
  ],
),

          );
        },
      ),
    );
  }
}
