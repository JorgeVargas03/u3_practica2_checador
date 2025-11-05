import 'package:flutter/material.dart';
import 'package:u3_practica2_checador/basedatos.dart';
import 'package:u3_practica2_checador/horario.dart';
import 'package:u3_practica2_checador/profesor.dart';
import 'package:u3_practica2_checador/materia.dart';

class CapturaHorario extends StatefulWidget {
  final Horario? horarioParaEditar;

  const CapturaHorario({super.key, this.horarioParaEditar});

  @override
  State<CapturaHorario> createState() => _CapturaHorarioState();
}

class _CapturaHorarioState extends State<CapturaHorario> {
  final _formKey = GlobalKey<FormState>();
  // --- ELIMINADOS ---
  // final TextEditingController nprofesorController = TextEditingController();
  // final TextEditingController nmatController = TextEditingController();
  final TextEditingController horaController = TextEditingController();
  final TextEditingController edificioController = TextEditingController();
  final TextEditingController salonController = TextEditingController();

  bool esModoEdicion = false;
  int? _nhorarioActual;

  // --- AÑADIDO: Listas para los Dropdowns ---
  List<Profesor> _listaProfesores = [];
  List<Materia> _listaMaterias = [];

  // --- AÑADIDO: Variables para guardar la selección ---
  String? _profesorSeleccionado;
  String? _materiaSeleccionada;


  @override
  void initState() {
    super.initState();
    _cargarDatosDropdowns(); // <-- AÑADIDO: Cargar datos al iniciar

    if (widget.horarioParaEditar != null) {
      setState(() {
        esModoEdicion = true;
        _nhorarioActual = widget.horarioParaEditar!.nhorario;

        // --- MODIFICADO: Asignar a las variables de selección ---
        _profesorSeleccionado = widget.horarioParaEditar!.nprofesor;
        _materiaSeleccionada = widget.horarioParaEditar!.nmat;

        // (Los controladores de texto se quedan igual)
        horaController.text = widget.horarioParaEditar!.hora;
        edificioController.text = widget.horarioParaEditar!.edificio;
        salonController.text = widget.horarioParaEditar!.salon;
      });
    }
  }

  // --- AÑADIDO: Método para cargar datos de Profesores y Materias ---
  Future<void> _cargarDatosDropdowns() async {
    List<Profesor> profes = await DB.mostrarTodoProfesor();
    List<Materia> materias = await DB.mostrarTodoMateria();
    setState(() {
      _listaProfesores = profes;
      _listaMaterias = materias;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(esModoEdicion ? "Editar Horario" : "Capturar Horario"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (esModoEdicion)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Editando Horario ID: $_nhorarioActual",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                  ),

                // --- INICIO: Dropdown de Profesor (REEMPLAZO) ---
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Profesor",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.blueGrey.shade50,
                  ),
                  value: _profesorSeleccionado,
                  items: _listaProfesores.map((profesor) {
                    return DropdownMenuItem<String>(
                      value: profesor.nprofesor, // El valor es el ID (FK)
                      child: Text(profesor.nombre), // El texto es el Nombre
                    );
                  }).toList(),
                  onChanged: (valor) {
                    setState(() {
                      _profesorSeleccionado = valor;
                    });
                  },
                  validator: (v) => v == null ? "Seleccione un profesor" : null,
                ),
                // --- FIN: Dropdown de Profesor ---

                SizedBox(height: 20),

                // --- INICIO: Dropdown de Materia (REEMPLAZO) ---
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Materia",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.blueGrey.shade50,
                  ),
                  value: _materiaSeleccionada,
                  items: _listaMaterias.map((materia) {
                    return DropdownMenuItem<String>(
                      value: materia.nmat, // El valor es el ID (FK)
                      child: Text(materia.descripcion), // El texto es la Descripción
                    );
                  }).toList(),
                  onChanged: (valor) {
                    setState(() {
                      _materiaSeleccionada = valor;
                    });
                  },
                  validator: (v) => v == null ? "Seleccione una materia" : null,
                ),
                // --- FIN: Dropdown de Materia ---

                SizedBox(height: 20),
                TextFormField(
                  controller: horaController,
                  decoration: InputDecoration(
                    labelText: "Hora (Ej: 8:00am - 10:00am)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: edificioController,
                  decoration: InputDecoration(
                    labelText: "Edificio",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: salonController,
                  decoration: InputDecoration(
                    labelText: "Salón",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    // --- MODIFICADO: Añadir validación de los dropdowns ---
                    if (_formKey.currentState!.validate()) {
                      Horario h = Horario(
                        nhorario: esModoEdicion ? _nhorarioActual : null,

                        // --- MODIFICADO: Usar las variables de selección ---
                        nprofesor: _profesorSeleccionado!,
                        nmat: _materiaSeleccionada!,

                        hora: horaController.text.trim(),
                        edificio: edificioController.text.trim(),
                        salon: salonController.text.trim(),
                      );

                      if (esModoEdicion) {
                        await DB.actualizarHorario(h);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Horario actualizado")),
                        );
                      } else {
                        await DB.insertarHorario(h);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Horario guardado")),
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: esModoEdicion ? Colors.green : Colors.blueGrey,
                  ),
                  child: Text(esModoEdicion ? "Actualizar" : "Guardar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}