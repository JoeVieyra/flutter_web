import 'package:flutter/material.dart';
import 'package:flutter_web/services/empleado_service.dart';
import 'colaborador_fields.dart';

class ColaboradorForm extends StatefulWidget {
  const ColaboradorForm({super.key});

  @override
  State<ColaboradorForm> createState() => _ColaboradorFormState();
}

class _ColaboradorFormState extends State<ColaboradorForm> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> controllers = {
    'nombre': TextEditingController(),
    'correo': TextEditingController(),
    'rfc': TextEditingController(),
    'domicilioFiscal': TextEditingController(),
    'curp': TextEditingController(),
    'nss': TextEditingController(),
    'salarioDiario': TextEditingController(),
    'salario': TextEditingController(),
    'claveEntidad': TextEditingController(),
  };

  DateTime? _fechaInicio;
  String? _tipoContrato;
  String? _departamento;
  String? _puesto;
  String? _estado;

  final List<String> tiposContrato = ['Indefinido', 'Temporal', 'Honorarios'];
  final List<String> departamentos = ['TI', 'Contabilidad', 'Recursos Humanos'];
  final List<String> puestos = ['Desarrollador', 'Contador', 'Administrador'];
  final List<String> estados = [
    'Aguascalientes', 'Baja California', 'Campeche', 'Chiapas', 'Chihuahua',
    'CDMX', 'Durango', 'Estado de México', 'Jalisco', 'Nuevo León',
    'Puebla', 'Veracruz'
  ];

  void _guardar() async {
  if (_formKey.currentState!.validate()) {
    final data = {
      ...controllers.map((k, v) => MapEntry(k, v.text)),
      'fechaInicioLaboral': _fechaInicio?.toIso8601String(),
      'tipoContrato': _tipoContrato,
      'departamento': _departamento,
      'puesto': _puesto,
      'estado': _estado,
    };

    print("Enviando colaborador: $data");

    final guardado = await EmpleadoService.crearEmpleado(data);

    if (guardado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Colaborador guardado correctamente')),
      );
      Navigator.pop(context); // Opcional: volver a la vista anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar el colaborador')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          buildTextField(controllers['nombre']!, 'Nombre'),
          buildTextField(controllers['correo']!, 'Correo', email: true),
          buildTextField(controllers['rfc']!, 'RFC'),
          buildTextField(controllers['domicilioFiscal']!, 'Domicilio Fiscal'),
          buildTextField(controllers['curp']!, 'CURP'),
          buildTextField(controllers['nss']!, 'Número de Seguridad Social'),
          buildDatePicker(context, _fechaInicio, (value) {
            setState(() {
              _fechaInicio = value;
            });
          }),
          buildDropdown('Tipo de Contrato', tiposContrato, _tipoContrato,
              (val) => setState(() => _tipoContrato = val)),
          buildDropdown('Departamento', departamentos, _departamento,
              (val) => setState(() => _departamento = val)),
          buildDropdown('Puesto', puestos, _puesto,
              (val) => setState(() => _puesto = val)),
          buildTextField(controllers['salarioDiario']!, 'Salario Diario', numeric: true),
          buildTextField(controllers['salario']!, 'Salario', numeric: true),
          buildTextField(controllers['claveEntidad']!, 'Clave Entidad'),
          buildDropdown('Estado', estados, _estado,
              (val) => setState(() => _estado = val)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
        ],
      ),
    );
  }
}
