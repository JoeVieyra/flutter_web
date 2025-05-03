class Colaborador {
  String nombre;
  String correo;
  String rfc;
  String domicilioFiscal;
  String curp;
  String nss;
  String fechaInicio;
  String tipoContrato;
  String departamento;
  String puesto;
  double salarioDiario;
  double salario;
  String claveEntidad;
  String estado;
  bool activo;

  Colaborador({
    required this.nombre,
    required this.correo,
    required this.rfc,
    required this.domicilioFiscal,
    required this.curp,
    required this.nss,
    required this.fechaInicio,
    required this.tipoContrato,
    required this.departamento,
    required this.puesto,
    required this.salarioDiario,
    required this.salario,
    required this.claveEntidad,
    required this.estado,
    this.activo = true,
  });
}
