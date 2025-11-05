import 'package:flutter/material.dart';
import 'package:u3_practica2_checador/basedatos.dart';
import 'package:u3_practica2_checador/profesor.dart';

class CapturaProfesor extends StatefulWidget {
  final Profesor? profesorParaEditar; // <-- AÑADIDO: Objeto opcional

  const CapturaProfesor({super.key, this.profesorParaEditar}); // <-- AÑADIDO

  @override
  State<CapturaProfesor> createState() => _CapturaProfesorState();
}

class _CapturaProfesorState extends State<CapturaProfesor> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nprofesorController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController carreraController = TextEditingController();

  bool esModoEdicion = false; // <-- AÑADIDO

  @override
  void initState() {
    super.initState();
    // --- AÑADIDO: Lógica de Edición ---
    if (widget.profesorParaEditar != null) {
      setState(() {
        esModoEdicion = true;
        nprofesorController.text = widget.profesorParaEditar!.nprofesor;
        nombreController.text = widget.profesorParaEditar!.nombre;
        carreraController.text = widget.profesorParaEditar!.carrera;
      });
    }
    // --- FIN DE AÑADIDO ---
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // --- MODIFICADO ---
        title: Text(esModoEdicion ? "Editar Profesor" : "Capturar Profesor"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nprofesorController,
                // --- MODIFICADO: No se puede editar la Llave Primaria ---
                readOnly: esModoEdicion,
                decoration: InputDecoration(
                  labelText: "Clave del profesor (NPROFESOR)",
                  border: OutlineInputBorder(),
                  // --- AÑADIDO ---
                  fillColor: esModoEdicion ? Colors.grey[200] : Colors.white,
                  filled: true,
                ),
                validator: (value) =>
                value!.isEmpty ? "Campo obligatorio" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Campo obligatorio" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: carreraController,
                decoration: InputDecoration(
                  labelText: "Carrera",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Campo obligatorio" : null,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Profesor p = Profesor(
                      nprofesor: nprofesorController.text.trim(),
                      nombre: nombreController.text.trim(),
                      carrera: carreraController.text.trim(),
                    );

                    // --- MODIFICADO: Lógica de Guardar/Actualizar ---
                    if (esModoEdicion) {
                      await DB.actualizarProfesor(p);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Profesor actualizado")),
                      );
                    } else {
                      await DB.insertarProfesor(p);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Profesor guardado")),
                      );
                    }
                    // --- FIN DE MODIFICADO ---

                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: esModoEdicion ? Colors.green : Colors.blueGrey, // <-- MODIFICADO
                ),
                // --- MODIFICADO ---
                child: Text(esModoEdicion ? "Actualizar" : "Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}