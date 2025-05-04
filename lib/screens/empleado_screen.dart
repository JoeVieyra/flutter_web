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
        title: const Text('Eliminar empleado'),
        content: Text('¿Deseas eliminar a ${empleado.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final eliminado = await EmpleadoService.eliminarEmpleado(empleado.id);
              if (eliminado) {
                await cargarEmpleados();
                Navigator.of(context).pop();
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
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
        title: const Text('Editar empleado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: curpController,
              decoration: const InputDecoration(
                labelText: 'CURP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: rfcController,
              decoration: const InputDecoration(
                labelText: 'RFC',
                border: OutlineInputBorder(),
              ),
            ),
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
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empleados'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: busquedaController,
              onChanged: filtrarEmpleados,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, CURP o RFC',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
      ),
      body: empleadosFiltrados.isEmpty
          ? const Center(child: Text('No se encontraron empleados'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: empleadosFiltrados.length,
              itemBuilder: (context, index) {
                final empleado = empleadosFiltrados[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      empleado.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('CURP: ${empleado.curp}\nRFC: ${empleado.rfc}'),
                    isThreeLine: true,
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => mostrarDialogoEdicion(empleado),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => confirmarEliminacion(empleado),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
