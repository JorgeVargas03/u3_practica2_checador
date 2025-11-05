import 'package:flutter/material.dart';
import 'package:u3_practica2_checador/basedatos.dart';
import 'package:u3_practica2_checador/asistencia.dart';
import 'package:u3_practica2_checador/capturarAsistencia.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

class MostrarAsistencias extends StatefulWidget {
  const MostrarAsistencias({super.key});

  @override
  State<MostrarAsistencias> createState() => _MostrarAsistenciasState();
}

class _MostrarAsistenciasState extends State<MostrarAsistencias> {
  List<Asistencia> asistencias = [];

  @override
  void initState() {
    super.initState();
    _cargarAsistencias();
  }

  Future<void> _cargarAsistencias() async {
    List<Asistencia> lista = await DB.mostrarTodoAsistencia();
    setState(() {
      asistencias = lista;
    });
  }

  Future<void> _navegarAEditar(Asistencia asistencia) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CapturaAsistencia(asistenciaParaEditar: asistencia),
      ),
    );
    _cargarAsistencias();
  }

  Future<void> _navegarACapturar() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CapturaAsistencia()),
    );
    _cargarAsistencias();
  }

  void _confirmarEliminar(int idasistencia) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Eliminación"),
          content: Text("¿Seguro que deseas eliminar la asistencia ID $idasistencia?"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await DB.eliminarAsistencia(idasistencia);
                Navigator.of(context).pop();
                _cargarAsistencias();
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
        title: Text("Asistencias Registradas"),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: asistencias.length,
        itemBuilder: (context, index) {
          Asistencia a = asistencias[index];
          String fechaFormateada = DateFormat('yyyy-MM-dd').format(a.fecha);
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            // Cambiamos el color de la tarjeta basado en la asistencia
            color: a.asistencia ? Colors.green[50] : Colors.red[50],
            child: ListTile(
              leading: Icon(
                a.asistencia ? Icons.check_circle_outline : Icons.highlight_off,
                color: a.asistencia ? Colors.green : Colors.red,
              ),
              title: Text("Horario ID: ${a.nhorario}", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("ID: ${a.idasistencia} | Fecha: $fechaFormateada"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _navegarAEditar(a);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmarEliminar(a.idasistencia!);
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