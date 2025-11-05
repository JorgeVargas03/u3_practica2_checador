class Horario {
  int? nhorario;
  String nprofesor;
  String nmat;
  String hora;
  String edificio;
  String salon;

  Horario({
    this.nhorario,
    required this.nprofesor,
    required this.nmat,
    required this.hora,
    required this.edificio,
    required this.salon,
  });

  Map<String, dynamic> toJson() {
    return {
      'NPROFESOR': nprofesor,
      'NMAT': nmat,
      'HORA': hora,
      'EDIFICIO': edificio,
      'SALON': salon,
    };
  }
}