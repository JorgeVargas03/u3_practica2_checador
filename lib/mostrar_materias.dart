import 'package:flutter/material.dart';
import 'package:u3_practica2_checador/basedatos.dart';
import 'package:u3_practica2_checador/materia.dart';
import 'package:u3_practica2_checador/capturarMateria.dart';

class MostrarMaterias extends StatefulWidget {
  const MostrarMaterias({super.key});

  @override
  State<MostrarMaterias> createState() => _MostrarMateriasState();
}

class _MostrarMateriasState extends State<MostrarMaterias> {
  List<Materia> materias = [];

  @override
  void initState() {
    super.initState();
    _cargarMaterias();
  }

  Future<void> _cargarMaterias() async {
    List<Materia> lista = await DB.mostrarTodoMateria();
    setState(() {
      materias = lista;
    });
  }

  Future<void> _navegarAEditar(Materia materia) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CapturaMateria(materiaParaEditar: materia),
      ),
    );
    _cargarMaterias();
  }

  Future<void> _navegarACapturar() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CapturaMateria()),
    );
    _cargarMaterias();
  }

  void _confirmarEliminar(String nmat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Eliminación"),
          content: Text("¿Seguro que deseas eliminar $nmat? \n(Se eliminarán sus horarios y asistencias)"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await DB.eliminarMateria(nmat);
                Navigator.of(context).pop();
                _cargarMaterias();
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
        title: Text("Materias Registradas"),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: materias.length,
        itemBuilder: (context, index) {
          Materia m = materias[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              leading: Icon(Icons.book_outlined, color: Colors.blueGrey[700]),
              title: Text(m.descripcion, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Clave: ${m.nmat}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _navegarAEditar(m);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmarEliminar(m.nmat);
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