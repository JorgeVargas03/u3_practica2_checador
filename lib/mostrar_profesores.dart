import 'package:flutter/material.dart';
import 'package:u3_practica2_checador/basedatos.dart';
import 'package:u3_practica2_checador/profesor.dart';
import 'package:u3_practica2_checador/capturarProfesor.dart';

class MostrarProfesores extends StatefulWidget {
  const MostrarProfesores({super.key});

  @override
  State<MostrarProfesores> createState() => _MostrarProfesoresState();
}

class _MostrarProfesoresState extends State<MostrarProfesores> {
  List<Profesor> profesores = [];

  @override
  void initState() {
    super.initState();
    _cargarProfesores();
  }

  // --- MÉTODO PARA CARGAR DATOS ---
  Future<void> _cargarProfesores() async {
    List<Profesor> lista = await DB.mostrarTodoProfesor();
    setState(() {
      profesores = lista;
    });
  }

  // --- MÉTODO PARA NAVEGAR A EDITAR ---
  Future<void> _navegarAEditar(Profesor profesor) async {
    // Navegamos a la pantalla de captura y le pasamos el profesor
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CapturaProfesor(profesorParaEditar: profesor),
      ),
    );
    // Al volver, recargamos la lista
    _cargarProfesores();
  }

  // --- MÉTODO PARA NAVEGAR A CAPTURAR ---
  Future<void> _navegarACapturar() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CapturaProfesor()),
    );
    // Al volver, recargamos la lista
    _cargarProfesores();
  }

  // --- MÉTODO PARA CONFIRMAR ELIMINACIÓN ---
  void _confirmarEliminar(String nprofesor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Eliminación"),
          content: Text("¿Seguro que deseas eliminar a $nprofesor? \n(Se eliminarán sus horarios y asistencias)"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await DB.eliminarProfesor(nprofesor);
                Navigator.of(context).pop();
                _cargarProfesores(); // Recargamos la lista
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
        title: Text("Profesores Registrados"),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: profesores.length,
        itemBuilder: (context, index) {
          Profesor p = profesores[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              leading: Icon(Icons.person_outline, color: Colors.blueGrey[700]),
              title: Text(p.nombre, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("ID: ${p.nprofesor} - Carrera: ${p.carrera}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- BOTÓN DE ACTUALIZAR ---
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _navegarAEditar(p);
                    },
                  ),
                  // --- BOTÓN DE ELIMINAR ---
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmarEliminar(p.nprofesor);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // --- BOTÓN DE AÑADIR (CREATE) ---
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarACapturar,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}