import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:u3_practica2_checador/asistencia.dart';
import 'package:u3_practica2_checador/horario.dart';
import 'package:u3_practica2_checador/materia.dart';
import 'package:u3_practica2_checador/profesor.dart';

class DB {
  static Future<Database> _conectarDB() async {
    return openDatabase(
      join(await getDatabasesPath(), "practica2.db"),
      version: 1,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) async {
        // Tabla MATERIA
        await db.execute(
          "CREATE TABLE MATERIA(NMAT TEXT PRIMARY KEY, DESCRIPCION TEXT)",
        );

        // Tabla PROFESOR
        await db.execute(
          "CREATE TABLE PROFESOR(NPROFESOR TEXT PRIMARY KEY, NOMBRE TEXT, CARRERA TEXT)",
        );

        // Tabla HORARIO
        await db.execute(
          "CREATE TABLE HORARIO("
          "NHORARIO INTEGER PRIMARY KEY AUTOINCREMENT, "
          "NPROFESOR TEXT, "
          "NMAT TEXT, "
          "HORA TEXT, "
          "EDIFICIO TEXT, "
          "SALON TEXT, "
          "FOREIGN KEY(NPROFESOR) REFERENCES PROFESOR(NPROFESOR) "
          "ON DELETE CASCADE ON UPDATE CASCADE, "
          "FOREIGN KEY(NMAT) REFERENCES MATERIA(NMAT) "
          "ON DELETE CASCADE ON UPDATE CASCADE"
          ")",
        );

        // Tabla ASISTENCIA
        await db.execute(
          "CREATE TABLE ASISTENCIA("
          "IDASISTENCIA INTEGER PRIMARY KEY AUTOINCREMENT, "
          "NHORARIO INTEGER, "
          "FECHA TEXT CHECK (DATE(FECHA) IS NOT NULL), " // Se guarda la fecha como texto tipo 'YYYY-MM-DD'
          "ASISTENCIA BOOLEAN, "
          "FOREIGN KEY(NHORARIO) REFERENCES HORARIO(NHORARIO) "
          "ON DELETE CASCADE ON UPDATE CASCADE"
          ")",
        );
      },
    );
  }

  // METODOS DE INSERCION
  static Future<int> insertarMateria(Materia m) async {
    Database base = await _conectarDB();
    return base.insert("MATERIA", m.toJson());
  }

  static Future<int> insertarProfesor(Profesor p) async {
    Database base = await _conectarDB();
    return base.insert("PROFESOR", p.toJson());
  }

  static Future<int> insertarHorario(Horario h) async {
    Database base = await _conectarDB();
    return base.insert("HORARIO", h.toJson());
  }

  static Future<int> insertarAsistencia(Asistencia a) async {
    Database base = await _conectarDB();
    return base.insert("ASISTENCIA", a.toJson());
  }

  // METODOS DE CONSULTA
  static Future<List<Materia>> mostrarTodoMateria() async {
    Database base = await _conectarDB();
    List<Map<String, dynamic>> temp = await base.query("MATERIA");
    return List.generate(temp.length, (contador) {
      return Materia(
        nmat: temp[contador]['NMAT'],
        descripcion: temp[contador]['DESCRIPCION'],
      );
    });
  }

  static Future<List<Profesor>> mostrarTodoProfesor() async {
    Database base = await _conectarDB();
    List<Map<String, dynamic>> temp = await base.query("PROFESOR");
    return List.generate(temp.length, (contador) {
      return Profesor(
        nprofesor: temp[contador]['NPROFESOR'],
        nombre: temp[contador]['NOMBRE'],
        carrera: temp[contador]['CARRERA'],
      );
    });
  }

  static Future<List<Horario>> mostrarTodoHorario() async {
    Database base = await _conectarDB();
    List<Map<String, dynamic>> temp = await base.query("HORARIO");
    return List.generate(temp.length, (contador) {
      return Horario(
        nhorario: temp[contador]['NHORARIO'],
        nprofesor: temp[contador]['NPROFESOR'],
        nmat: temp[contador]['NMAT'],
        hora: temp[contador]['HORA'],
        edificio: temp[contador]['EDIFICIO'],
        salon: temp[contador]['SALON'],
      );
    });
  }

  static Future<List<Asistencia>> mostrarTodoAsistencia() async {
    Database base = await _conectarDB();
    List<Map<String, dynamic>> temp = await base.query("ASISTENCIA");
    return List.generate(temp.length, (contador) {
      return Asistencia(
        idasistencia: temp[contador]['IDASISTENCIA'],
        nhorario: temp[contador]['NHORARIO'],
        fecha: DateTime.parse(temp[contador]['FECHA']),
        asistencia: temp[contador]['ASISTENCIA'] == 1,
      );
    });
  }

  // METODOS DE ELIMINAR
  static Future<int> eliminarMateria(String nmat) async {
    Database base = await _conectarDB();
    return base.delete("MATERIA", where: "NMAT=?", whereArgs: [nmat]);
  }

  static Future<int> eliminarProfesor(String nprofesor) async {
    Database base = await _conectarDB();
    return base.delete(
      "PROFESOR",
      where: "NPROFESOR=?",
      whereArgs: [nprofesor],
    );
  }

  static Future<int> eliminarHorario(int nhorario) async {
    Database base = await _conectarDB();
    return base.delete("HORARIO", where: "NHORARIO=?", whereArgs: [nhorario]);
  }

  static Future<int> eliminarAsistencia(int idasistencia) async {
    Database base = await _conectarDB();
    return base.delete(
      "ASISTENCIA",
      where: "IDASISTENCIA=?",
      whereArgs: [idasistencia],
    );
  }

  // METODOS DE ACTUALIZAR
  static Future<int> actualizarMateria(Materia m) async {
    Database base = await _conectarDB();
    return base.update(
      "MATERIA",
      m.toJson(),
      where: "NMAT=?",
      whereArgs: [m.nmat],
    );
  }

  static Future<int> actualizarProfesor(Profesor p) async {
    Database base = await _conectarDB();
    return base.update(
      "PROFESOR",
      p.toJson(),
      where: "NPROFESOR=?",
      whereArgs: [p.nprofesor],
    );
  }

  static Future<int> actualizarHorario(Horario h) async {
    Database base = await _conectarDB();
    return base.update(
      "HORARIO",
      h.toJson(),
      where: "NHORARIO=?",
      whereArgs: [h.nhorario],
    );
  }

  static Future<int> actualizarAsistencia(Asistencia a) async {
    Database base = await _conectarDB();
    return base.update(
      "ASISTENCIA",
      a.toJson(),
      where: "IDASISTENCIA=?",
      whereArgs: [a.idasistencia],
    );
  }

  // --- CONSULTAS AVANZADAS ---

  // 1. Mostrar todos los profesores que asistieron en una fecha específica
  static Future<List<Map<String, dynamic>>> profesoresPorFecha(
    String fecha,
  ) async {
    Database base = await _conectarDB();
    // Usamos 'DISTINCT P.NOMBRE' para no repetir profesores si dieron varias clases
    return base.rawQuery(
      '''
    SELECT DISTINCT P.NOMBRE, P.CARRERA
    FROM ASISTENCIA A
    JOIN HORARIO H ON A.NHORARIO = H.NHORARIO
    JOIN PROFESOR P ON H.NPROFESOR = P.NPROFESOR
    WHERE A.FECHA = ? AND A.ASISTENCIA = 1
    ''',
      [fecha], // fecha debe estar en formato 'YYYY-MM-DD'
    );
  }

  // 2. Todos los profesores que tienen clase a una hora X en un edificio Y
  static Future<List<Map<String, dynamic>>> profesoresPorHorayEdificio(
    String hora,
    String edificio,
  ) async {
    Database base = await _conectarDB();
    return base.rawQuery(
      '''
    SELECT P.NOMBRE, M.DESCRIPCION, H.SALON
    FROM HORARIO H
    JOIN PROFESOR P ON H.NPROFESOR = P.NPROFESOR
    JOIN MATERIA M ON H.NMAT = M.NMAT
    WHERE H.HORA = ? AND H.EDIFICIO = ?
    ''',
      [hora, edificio],
    );
  }

  // 3. Mostrar los horarios de hoy con NOMBRES, no solo IDs
  // Esta la usaremos para la pantalla principal de "Pasar Asistencia"
  static Future<List<Map<String, dynamic>>> getHorariosConNombres() async {
    Database base = await _conectarDB();
    // Hacemos JOIN de 3 tablas: HORARIO, PROFESOR y MATERIA
    return base.rawQuery('''
    SELECT 
      H.NHORARIO, H.HORA, H.EDIFICIO, H.SALON,
      P.NOMBRE AS NOMBRE_PROFESOR,
      M.DESCRIPCION AS NOMBRE_MATERIA
    FROM HORARIO H
    JOIN PROFESOR P ON H.NPROFESOR = P.NPROFESOR
    JOIN MATERIA M ON H.NMAT = M.NMAT
    ORDER BY H.HORA
    ''');
  }
}
