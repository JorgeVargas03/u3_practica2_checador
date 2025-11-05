class Materia {
  String nmat;
  String descripcion;

  Materia({
    required this.nmat,
    required this.descripcion,
  });

  Map<String, dynamic> toJson() {
    return {
      'NMAT': nmat,
      'DESCRIPCION': descripcion,
    };
  }
}