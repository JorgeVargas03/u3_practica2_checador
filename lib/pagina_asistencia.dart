import 'package:flutter/material.dart';
import 'package:u3_practica2_checador/asistencia.dart';
import 'package:u3_practica2_checador/basedatos.dart';
import 'package:intl/intl.dart';

class PaginaAsistencia extends StatefulWidget {
  const PaginaAsistencia({super.key});

  @override
  State<PaginaAsistencia> createState() => _PaginaAsistenciaState();
}

class _PaginaAsistenciaState extends State<PaginaAsistencia> {
  // Usamos un FutureBuilder para manejar la carga de datos
  late Future<List<Map<String, dynamic>>> _horariosFuture;

  @override
  void initState() {
    super.initState();
    _horariosFuture = DB.getHorariosConNombres();
  }

  // Función para recargar los datos
  void _recargarHorarios() {
    setState(() {
      _horariosFuture = DB.getHorariosConNombres();
    });
  }

  @override
  Widget build(BuildContext context) {
    String fechaHoy = DateFormat('EEEE, d MMMM y', 'es_MX').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text("Pase de Asistencia"),
        backgroundColor: Colors.blueGrey,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              fechaHoy.toUpperCase(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _horariosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No hay horarios registrados para hoy."));
          }

          // ¡Lista Dinámica!
          List<Map<String, dynamic>> horarios = snapshot.data!;
          return ListView.builder(
            itemCount: horarios.length,
            itemBuilder: (context, index) {
              var horario = horarios[index];
              return _buildHorarioCard(context, horario);
            },
          );
        },
      ),
    );
  }

  // --- Widget Estético (Card) ---
  Widget _buildHorarioCard(BuildContext context, Map<String, dynamic> horario) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          // --- Widget Avanzado (BottomSheet) ---
          _mostrarBottomSheetAsistencia(context, horario);
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icono de Hora
              Column(
                children: [
                  Icon(Icons.schedule, color: Colors.blueGrey, size: 30),
                  SizedBox(height: 4),
                  Text(
                    horario['HORA'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey[800]),
                  ),
                ],
              ),
              SizedBox(width: 16),
              // Detalles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      horario['NOMBRE_MATERIA'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      horario['NOMBRE_PROFESOR'],
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          "${horario['EDIFICIO']} - ${horario['SALON']}",
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Avanzado (BottomSheet) ---
  void _mostrarBottomSheetAsistencia(BuildContext context, Map<String, dynamic> horario) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Registrar Asistencia",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Prof: ${horario['NOMBRE_PROFESOR']}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Materia: ${horario['NOMBRE_MATERIA']}",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // --- Botón ASISTIÓ ---
                  ElevatedButton.icon(
                    icon: Icon(Icons.check),
                    label: Text("Asistió"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: () {
                      _guardarAsistencia(horario['NHORARIO'], true);
                      Navigator.pop(context); // Cierra el BottomSheet
                    },
                  ),
                  // --- Botón FALTÓ ---
                  ElevatedButton.icon(
                    icon: Icon(Icons.close),
                    label: Text("Faltó"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: () {
                      _guardarAsistencia(horario['NHORARIO'], false);
                      Navigator.pop(context); // Cierra el BottomSheet
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // --- Lógica para guardar la asistencia ---
  Future<void> _guardarAsistencia(int nhorario, bool asistio) async {
    Asistencia a = Asistencia(
      nhorario: nhorario,
      fecha: DateTime.now(), // Guarda la fecha actual
      asistencia: asistio,
    );
    await DB.insertarAsistencia(a);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Asistencia (${asistio ? 'Presente' : 'Ausente'}) guardada.",
        ),
        backgroundColor: asistio ? Colors.green : Colors.red,
      ),
    );
  }
}