import 'package:flutter/material.dart';
import 'package:u3_practica2_checador/basedatos.dart';
import 'package:intl/intl.dart';

class PaginaReportes extends StatefulWidget {
  const PaginaReportes({super.key});

  @override
  State<PaginaReportes> createState() => _PaginaReportesState();
}

class _PaginaReportesState extends State<PaginaReportes> {
  // --- Controladores para el Tab 1 (Por Hora/Edificio) ---
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _edificioController = TextEditingController();
  List<Map<String, dynamic>> _resultadosHorario = [];

  // --- Controladores para el Tab 2 (Asistencia por Fecha) ---
  DateTime? _fechaSeleccionada;
  List<Map<String, dynamic>> _resultadosFecha = [];

  // --- Método para Consulta 1 ---
  Future<void> _buscarPorHorario() async {
    if (_horaController.text.isEmpty || _edificioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Debe llenar ambos campos: Hora y Edificio")));
      return;
    }
    var resultados = await DB.profesoresPorHorayEdificio(
        _horaController.text.trim(), _edificioController.text.trim());
    setState(() {
      _resultadosHorario = resultados;
    });
  }

  // --- Método para Consulta 2 ---
  Future<void> _buscarPorFecha() async {
    if (_fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Debe seleccionar una fecha")));
      return;
    }
    // Formateamos la fecha a 'YYYY-MM-DD' para SQLite
    String fechaFormateada = _fechaSeleccionada!.toIso8601String().split('T')[0];

    var resultados = await DB.profesoresPorFecha(fechaFormateada);
    setState(() {
      _resultadosFecha = resultados;
    });
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? seleccion = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (seleccion != null) {
      setState(() {
        _fechaSeleccionada = seleccion;
      });
      // Opcional: buscar automáticamente al seleccionar fecha
      _buscarPorFecha();
    }
  }


  @override
  Widget build(BuildContext context) {
    // Usamos DefaultTabController para el objeto avanzado "Tabs"
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reportes y Consultas"),
          backgroundColor: Colors.blueGrey,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.location_city), text: "Por Edificio/Hora"),
              Tab(icon: Icon(Icons.calendar_today), text: "Asistencia por Fecha"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- PESTAÑA 1: Por Hora y Edificio ---
            _buildTabHorarioEdificio(),

            // --- PESTAÑA 2: Asistencia por Fecha ---
            _buildTabAsistenciaFecha(),
          ],
        ),
      ),
    );
  }


  // --- Widget para la Pestaña 1 ---
  Widget _buildTabHorarioEdificio() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _horaController,
            decoration: InputDecoration(labelText: "Hora (Ej: 8am)", border: OutlineInputBorder()),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _edificioController,
            decoration: InputDecoration(labelText: "Edificio (Ej: UD)", border: OutlineInputBorder()),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _buscarPorHorario,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
            child: Text("Buscar Clases"),
          ),
          SizedBox(height: 10),
          Divider(),
          // --- Lista Dinámica de Resultados ---
          Expanded(
            child: _resultadosHorario.isEmpty
                ? Center(child: Text("No se encontraron resultados."))
                : ListView.builder(
              itemCount: _resultadosHorario.length,
              itemBuilder: (context, index) {
                var item = _resultadosHorario[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.person_pin, color: Colors.blueGrey),
                    title: Text(item['NOMBRE'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Materia: ${item['DESCRIPCION']} | Salón: ${item['SALON']}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget para la Pestaña 2 ---
  Widget _buildTabAsistenciaFecha() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Selector de fecha
          Row(
            children: [
              Expanded(
                child: Text(
                  _fechaSeleccionada == null
                      ? "Seleccione una fecha"
                      : "Fecha: ${DateFormat('yyyy-MM-dd').format(_fechaSeleccionada!)}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () => _seleccionarFecha(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                child: const Text("Elegir fecha"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(),
          // --- Lista Dinámica de Resultados ---
          Expanded(
            child: _resultadosFecha.isEmpty
                ? Center(child: Text("No se encontraron profesores que asistieron ese día."))
                : ListView.builder(
              itemCount: _resultadosFecha.length,
              itemBuilder: (context, index) {
                var item = _resultadosFecha[index];
                return Card(
                  color: Colors.green[50], // Tono verde por asistencia
                  child: ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text(item['NOMBRE'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Carrera: ${item['CARRERA']}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}