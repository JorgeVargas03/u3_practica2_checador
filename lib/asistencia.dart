class Asistencia {
  int? idasistencia;
  int nhorario;
  DateTime fecha;
  bool asistencia;

  Asistencia({
    this.idasistencia,
    required this.nhorario,
    required this.fecha,
    required this.asistencia,
  });

  Map<String, dynamic> toJson() {
    return {
      'NHORARIO': nhorario,
      // Se guarda en formato ISO (YYYY-MM-DD)
      'FECHA': fecha.toIso8601String().split('T')[0],
      'ASISTENCIA': asistencia ? 1 : 0,
    };
  }

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      idasistencia: json['IDASISTENCIA'],
      nhorario: json['NHORARIO'],
      fecha: DateTime.parse(json['FECHA']),
      asistencia: json['ASISTENCIA'] == 1,
    );
  }
}