import 'package:flutter/material.dart';
import 'package:u3_practica2_checador/basedatos.dart';
import 'package:u3_practica2_checador/materia.dart';

class CapturaMateria extends StatefulWidget {
  final Materia? materiaParaEditar; // <-- AÑADIDO

  const CapturaMateria({super.key, this.materiaParaEditar}); // <-- AÑADIDO

  @override
  State<CapturaMateria> createState() => _CapturaMateriaState();
}

class _CapturaMateriaState extends State<CapturaMateria> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nmatController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  bool esModoEdicion = false; // <-- AÑADIDO

  @override
  void initState() {
    super.initState();
    // --- AÑADIDO: Lógica de Edición ---
    if (widget.materiaParaEditar != null) {
      setState(() {
        esModoEdicion = true;
        nmatController.text = widget.materiaParaEditar!.nmat;
        descripcionController.text = widget.materiaParaEditar!.descripcion;
      });
    }
    // --- FIN DE AÑADIDO ---
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // --- MODIFICADO ---
        title: Text(esModoEdicion ? "Editar Materia" : "Capturar Materia"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nmatController,
                // --- MODIFICADO ---
                readOnly: esModoEdicion,
                decoration: InputDecoration(
                  labelText: "Clave de materia (NMAT)",
                  border: OutlineInputBorder(),
                  fillColor: esModoEdicion ? Colors.grey[200] : Colors.white,
                  filled: true,
                ),
                validator: (value) =>
                value!.isEmpty ? "Campo obligatorio" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Campo obligatorio" : null,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Materia m = Materia(
                      nmat: nmatController.text.trim(),
                      descripcion: descripcionController.text.trim(),
                    );

                    // --- MODIFICADO ---
                    if (esModoEdicion) {
                      await DB.actualizarMateria(m);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Materia actualizada")));
                    } else {
                      await DB.insertarMateria(m);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Materia guardada")));
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