import 'package:flutter/material.dart';
import 'package:u3_practica2_checador/home.dart'; // Tu pantalla CRUD original
import 'package:u3_practica2_checador/pagina_asistencia.dart';
import 'package:u3_practica2_checador/pagina_reportes.dart';

class NavegacionPage extends StatefulWidget {
  const NavegacionPage({super.key});

  @override
  State<NavegacionPage> createState() => _NavegacionPageState();
}

class _NavegacionPageState extends State<NavegacionPage> {
  int _indiceSeleccionado = 0;

  // Lista de pantallas para el BottomNav
  static const List<Widget> _paginas = <Widget>[
    PaginaAsistencia(), // Pestaña 0: Pasar Asistencia
    PaginaReportes(),   // Pestaña 1: Reportes
    Home(),             // Pestaña 2: Administración
  ];

  void _onItemTapped(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _paginas.elementAt(_indiceSeleccionado),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Asistencia',
            activeIcon: Icon(Icons.check_circle),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Reportes',
            activeIcon: Icon(Icons.bar_chart),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined),
            label: 'Administrar',
            activeIcon: Icon(Icons.admin_panel_settings),
          ),
        ],
        currentIndex: _indiceSeleccionado,
        selectedItemColor: Colors.blueGrey[800],
        unselectedItemColor: Colors.blueGrey[300],
        onTap: _onItemTapped,
      ),
    );
  }
}