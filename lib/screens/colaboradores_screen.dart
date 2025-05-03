import 'package:flutter/material.dart';
import 'package:flutter_web/models/colaboradores.dart';


class ColaboradoresScreen extends StatefulWidget {
  const ColaboradoresScreen({super.key});

  @override
  State<ColaboradoresScreen> createState() => _ColaboradoresScreenState();
}

class _ColaboradoresScreenState extends State<ColaboradoresScreen> {
  final List<Colaborador> _colaboradores = [];
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  String _estadoSeleccionado = 'CDMX';
  final List<String> _estados = ['CDMX', 'Jalisco', 'Nuevo León', 'Puebla', 'Veracruz'];

  @override
  void initState() {
    super.initState();
    final campos = [
      'nombre',
      'correo',
      'rfc',
      'domicilio',
      'curp',
      'nss',
      'fecha',
      'tipo',
      'departamento',
      'puesto',
      'salarioDiario',
      'salario',
      'claveEntidad'
    ];
    for (var campo in campos) {
      _controllers[campo] = TextEditingController();
    }
  }

  void _guardarColaborador() {
    if (_formKey.currentState!.validate()) {
      final nuevo = Colaborador(
        nombre: _controllers['nombre']!.text,
        correo: _controllers['correo']!.text,
        rfc: _controllers['rfc']!.text,
        domicilioFiscal: _controllers['domicilio']!.text,
        curp: _controllers['curp']!.text,
        nss: _controllers['nss']!.text,
        fechaInicio: _controllers['fecha']!.text,
        tipoContrato: _controllers['tipo']!.text,
        departamento: _controllers['departamento']!.text,
        puesto: _controllers['puesto']!.text,
        salarioDiario: double.tryParse(_controllers['salarioDiario']!.text) ?? 0,
        salario: double.tryParse(_controllers['salario']!.text) ?? 0,
        claveEntidad: _controllers['claveEntidad']!.text,
        estado: _estadoSeleccionado,
      );
      setState(() {
        _colaboradores.add(nuevo);
      });
      _formKey.currentState!.reset();
      _controllers.forEach((_, c) => c.clear());
    }
  }

  void _eliminarColaborador(int index) {
    setState(() {
      _colaboradores[index].activo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Colaboradores')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: _controllers.entries.map((entry) {
                    return SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: entry.value,
                        decoration: InputDecoration(labelText: entry.key),
                        validator: (val) => val!.isEmpty ? 'Requerido' : null,
                      ),
                    );
                  }).toList()
                  ..add(
                    SizedBox(
                      width: 250,
                      child: DropdownButtonFormField<String>(
                        value: _estadoSeleccionado,
                        decoration: InputDecoration(labelText: 'Estado'),
                        items: _estados
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _estadoSeleccionado = val);
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _guardarColaborador,
                  child: Text('Guardar Colaborador'),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Text('Colaboradores Activos', style: TextStyle(fontWeight: FontWeight.bold)),
          Divider(),
          DataTable(
            columns: const [
              DataColumn(label: Text('Nombre')),
              DataColumn(label: Text('RFC')),
              DataColumn(label: Text('CURP')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: _colaboradores
                .asMap()
                .entries
                .where((e) => e.value.activo)
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.value.nombre)),
                      DataCell(Text(e.value.rfc)),
                      DataCell(Text(e.value.curp)),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Función para editar (más adelante)
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _eliminarColaborador(e.key),
                          ),
                        ],
                      )),
                    ],
                  ),
                )
                .toList(),
          ),
        ]),
      ),
    );
  }
}
