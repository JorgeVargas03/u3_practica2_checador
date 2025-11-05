import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para poder cerrar la app
import 'package:u3_practica2_checador/capturarAsistencia.dart';
import 'package:u3_practica2_checador/capturarHorario.dart';
import 'package:u3_practica2_checador/capturarMateria.dart';
import 'package:u3_practica2_checador/capturarProfesor.dart';

// Imports de las nuevas pantallas de "Mostrar"
import 'mostrar_asistencias.dart';
import 'mostrar_horarios.dart';
import 'mostrar_materias.dart';
import 'mostrar_profesores.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _obtenerTitulo(_index),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.blueGrey.shade50,
      body: contenido(),
      drawer: Drawer(
        child: Container(
          color: Colors.blueGrey.shade100,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueGrey),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "@Usuario147",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _itemDrawer(0, Icons.create_outlined, "Capturar", _index == 0),
              _itemDrawer(1, Icons.list_alt, "Mostrar", _index == 1),
              _itemDrawer(2, Icons.delete_outline, "Eliminar", _index == 2),
              _itemDrawer(3, Icons.edit_outlined, "Actualizar", _index == 3),
              SizedBox(height: 20),
              Divider(),
              // --- 2. AQUÍ ESTÁ EL CAMBIO ---
              _itemDrawer(4, Icons.exit_to_app, "Cerrar App", false), // Cambiado de "Recargar"
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  String _obtenerTitulo(int index) {
    switch (index) {
      case 0:
        return "Capturar Registros";
      case 1:
        return "Mostrar Registros";
      case 2:
        return "Eliminar Registros";
      case 3:
        return "Actualizar Registros";
      default:
        return "Administración";
    }
  }

  Widget? contenido() {
    switch (_index) {
      case 0:
        String? _tablaSeleccionada;

        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Capturar datos en:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Selecciona la tabla",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey.shade50,
                ),
                value: _tablaSeleccionada,
                items: [
                  DropdownMenuItem(value: 'MATERIA', child: Text('Materia')),
                  DropdownMenuItem(value: 'PROFESOR', child: Text('Profesor')),
                  DropdownMenuItem(value: 'HORARIO', child: Text('Horario')),
                  DropdownMenuItem(
                    value: 'ASISTENCIA',
                    child: Text('Asistencia'),
                  ),
                ],
                onChanged: (valor) {
                  setState(() {
                    _tablaSeleccionada = null;
                  });

                  if (valor == 'MATERIA')
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CapturaMateria()),
                    );
                  if (valor == 'PROFESOR')
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CapturaProfesor()),
                    );
                  if (valor == 'HORARIO')
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CapturaHorario()),
                    );
                  if (valor == 'ASISTENCIA')
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CapturaAsistencia()),
                    );
                },
              ),
              SizedBox(height: 30),
              Center(
                child: Icon(
                  Icons.file_upload_outlined,
                  size: 100,
                  color: Colors.blueGrey.shade200,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Selecciona una tabla para continuar",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey.shade700,
                  ),
                ),
              ),
            ],
          ),
        );

      case 1: // Mostrar
      case 2: // Eliminar
      case 3: // Actualizar
        return DefaultTabController(
          length: 4,
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.blueGrey[800],
                unselectedLabelColor: Colors.blueGrey[400],
                indicatorColor: Colors.blueGrey[800],
                indicatorWeight: 3.0,
                isScrollable: true,
                tabs: [
                  Tab(icon: Icon(Icons.person_outline), text: "Profesores"),
                  Tab(icon: Icon(Icons.book_outlined), text: "Materias"),
                  Tab(icon: Icon(Icons.schedule_outlined), text: "Horarios"),
                  Tab(icon: Icon(Icons.check_box_outlined), text: "Asistencias"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    MostrarProfesores(),
                    MostrarMaterias(),
                    MostrarHorarios(),
                    MostrarAsistencias(),
                  ],
                ),
              ),
            ],
          ),
        );

      default:
        return Center(child: Text("Seleccione una opción del menú."));
    }
  }

  Widget _itemDrawer(int indice, IconData icono, String texto, bool seleccionado) {
    return Material(
      color: seleccionado ? Colors.blueGrey.shade300 : Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _index = indice;
          });

          // --- 3. AQUÍ ESTÁ LA LÓGICA MODIFICADA ---
          if (indice != 4) {
            Navigator.pop(context); // Cierra el drawer
          } else {
            // El índice 4 (Cerrar App) cierra la aplicación
            SystemNavigator.pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Row(
            children: [
              Expanded(child: Icon(icono, size: 28, color: Colors.blueGrey[800])),
              Expanded(
                child: Text(texto, style: TextStyle(fontSize: 18, color: Colors.blueGrey[900])),
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}