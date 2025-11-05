import 'package:flutter/material.dart';
import 'package:u3_practica2_checador/asistencia.dart';
import 'package:u3_practica2_checador/basedatos.dart';
import 'package:u3_practica2_checador/horario.dart';

class CapturaAsistencia extends StatefulWidget {
  final Asistencia? asistenciaParaEditar; // <-- AÑADIDO

  const CapturaAsistencia({super.key, this.asistenciaParaEditar}); // <-- AÑADIDO

  @override
  State<CapturaAsistencia> createState() => _CapturaAsistenciaState();
}

class _CapturaAsistenciaState extends State<CapturaAsistencia> {
  final _formKey = GlobalKey<FormState>();
  DateTime? fechaSeleccionada;
  int? horarioSeleccionado;
  bool asistencia = false;
  List<Horario> horarios = [];

  bool esModoEdicion = false; // <-- AÑADIDO
  int? _idasistenciaActual; // <-- AÑADIDO

  @override
  void initState() {
    super.initState();
    _cargarHorarios();

    // --- AÑADIDO: Lógica de Edición ---
    if (widget.asistenciaParaEditar != null) {
      setState(() {
        esModoEdicion = true;
        _idasistenciaActual = widget.asistenciaParaEditar!.idasistencia;
        horarioSeleccionado = widget.asistenciaParaEditar!.nhorario;
        fechaSeleccionada = widget.asistenciaParaEditar!.fecha;
        asistencia = widget.asistenciaParaEditar!.asistencia;
      });
    }
    // --- FIN DE AÑADIDO ---
  }

  Future<void> _cargarHorarios() async {
    List<Horario> lista = await DB.mostrarTodoHorario();
    setState(() {
      horarios = lista;
    });
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? seleccion = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada ?? DateTime.now(), // <-- MODIFICADO
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (seleccion != null) {
      setState(() {
        fechaSeleccionada = seleccion;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // --- MODIFICADO ---
        title: Text(esModoEdicion ? "Editar Asistencia" : "Capturar Asistencia"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- AÑADIDO: Mostramos el ID solo si estamos editando ---
              if (esModoEdicion)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Editando Asistencia ID: $_idasistenciaActual",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                ),
              // Dropdown de horarios
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "Seleccione un horario",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey.shade50,
                ),
                value: horarioSeleccionado,
                items: horarios.isEmpty
                    ? []
                    : horarios.map((h) {
                  return DropdownMenuItem<int>(
                    value: h.nhorario!,
                    child: Text(
                      "ID Horario: ${h.nhorario} | ${h.nmat} - ${h.nprofesor}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    horarioSeleccionado = valor;
                  });
                },
                validator: (value) =>
                value == null ? "Debe seleccionar un horario" : null,
              ),
              const SizedBox(height: 20),

              // Selector de fecha
              Row(
                children: [
                  Expanded(
                    child: Text(
                      fechaSeleccionada == null
                          ? "Seleccione una fecha"
                          : "Fecha: ${fechaSeleccionada!.toLocal()}".split(' ')[0],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _seleccionarFecha(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    child: const Text("Elegir fecha"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Switch de asistencia
              SwitchListTile(
                title: const Text("¿Asistió?"),
                value: asistencia,
                onChanged: (valor) {
                  setState(() => asistencia = valor);
                },
              ),
              const SizedBox(height: 30),

              // Botón guardar
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      fechaSeleccionada != null) {
                    Asistencia a = Asistencia(
                      // --- MODIFICADO ---
                      idasistencia: esModoEdicion ? _idasistenciaActual : null,
                      nhorario: horarioSeleccionado!,
                      fecha: fechaSeleccionada!,
                      asistencia: asistencia,
                    );

                    // --- MODIFICADO ---
                    if (esModoEdicion) {
                      await DB.actualizarAsistencia(a);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Asistencia actualizada")),
                      );
                    } else {
                      await DB.insertarAsistencia(a);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Asistencia guardada")),
                      );
                    }
                    // --- FIN DE MODIFICADO ---

                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Por favor complete todos los campos")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  // --- MODIFICADO ---
                  backgroundColor: esModoEdicion ? Colors.green : Colors.blueGrey,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                // --- MODIFICADO ---
                child: Text(
                  esModoEdicion ? "Actualizar" : "Guardar",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}