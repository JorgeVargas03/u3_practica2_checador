import 'package:flutter/material.dart';
import 'package:u3_practica2_checador/basedatos.dart';
import 'package:u3_practica2_checador/horario.dart';
import 'package:u3_practica2_checador/capturarHorario.dart';

class MostrarHorarios extends StatefulWidget {
  const MostrarHorarios({super.key});

  @override
  State<MostrarHorarios> createState() => _MostrarHorariosState();
}

class _MostrarHorariosState extends State<MostrarHorarios> {
  List<Horario> horarios = [];

  @override
  void initState() {
    super.initState();
    _cargarHorarios();
  }

  Future<void> _cargarHorarios() async {
    List<Horario> lista = await DB.mostrarTodoHorario();
    setState(() {
      horarios = lista;
    });
  }

  Future<void> _navegarAEditar(Horario horario) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CapturaHorario(horarioParaEditar: horario),
      ),
    );
    _cargarHorarios();
  }

  Future<void> _navegarACapturar() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CapturaHorario()),
    );
    _cargarHorarios();
  }

  void _confirmarEliminar(int nhorario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Eliminación"),
          content: Text("¿Seguro que deseas eliminar el horario ID $nhorario? \n(Se eliminarán sus asistencias)"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await DB.eliminarHorario(nhorario);
                Navigator.of(context).pop();
                _cargarHorarios();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Horarios Registrados"),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: horarios.length,
        itemBuilder: (context, index) {
          Horario h = horarios[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              leading: Icon(Icons.schedule_outlined, color: Colors.blueGrey[700]),
              title: Text("Prof: ${h.nprofesor} - Mat: ${h.nmat}", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("ID: ${h.nhorario} | ${h.hora} | ${h.edificio} - ${h.salon}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _navegarAEditar(h);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmarEliminar(h.nhorario!);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarACapturar,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}