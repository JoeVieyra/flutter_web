class Empleado {
  final String id;
  final String nombre;
  final String correo;
  final String rfc;
  final String domicilioFiscal;
  final String curp;
  final String nss;
  final String salarioDiario;
  final String salario;
  final String claveEntidad;
  final String tipoContrato;
  final String departamento;
  final String puesto;
  final String estado;
  final DateTime fechaInicioLaboral;

  Empleado({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rfc,
    required this.domicilioFiscal,
    required this.curp,
    required this.nss,
    required this.salarioDiario,
    required this.salario,
    required this.claveEntidad,
    required this.tipoContrato,
    required this.departamento,
    required this.puesto,
    required this.estado,
    required this.fechaInicioLaboral,
  });

  // Método de conversión JSON -> Empleado
  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      id: json['_id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      correo: json['correo']?.toString() ?? '',
      rfc: json['rfc']?.toString() ?? '',
      domicilioFiscal: json['domicilioFiscal']?.toString() ?? '',
      curp: json['curp']?.toString() ?? '',
      nss: json['nss']?.toString() ?? '',
      salarioDiario: json['salarioDiario']?.toString() ?? '',
      salario: json['salario']?.toString() ?? '',
      claveEntidad: json['claveEntidad']?.toString() ?? '',
      tipoContrato: json['tipoContrato']?.toString() ?? '',
      departamento: json['departamento']?.toString() ?? '',
      puesto: json['puesto']?.toString() ?? '',
      estado: json['estado']?.toString() ?? '',
      fechaInicioLaboral: DateTime.parse(json['fechaInicioLaboral']?.toString() ?? ''),
    );
  }

  // Método de conversión Empleado -> JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'rfc': rfc,
      'domicilioFiscal': domicilioFiscal,
      'curp': curp,
      'nss': nss,
      'salarioDiario': salarioDiario,
      'salario': salario,
      'claveEntidad': claveEntidad,
      'tipoContrato': tipoContrato,
      'departamento': departamento,
      'puesto': puesto,
      'estado': estado,
      'fechaInicioLaboral': fechaInicioLaboral.toIso8601String(),
    };
  }
}

