# 🏫 Checador de Asistencia de Profesores (U3 Práctica 2)

Un proyecto móvil desarrollado en Flutter para la gestión y seguimiento de la asistencia de profesores en el aula, diseñado para ser utilizado por el personal de Recursos Humanos.

La aplicación implementa un CRUD completo sobre una base de datos SQLite y utiliza widgets avanzados de Flutter para una experiencia de usuario fluida y moderna.

---

## 👥 Integrantes

* Jorge Luis Vargas Partida
* Juan Alejandro Rodriguez Sanchez

---

## ✨ Características Principales

La aplicación se divide en tres secciones principales, accesibles a través de una `BottomNavigationBar`:

### 1. 📋 Pase de Asistencia (Pantalla Principal)
* Muestra el horario de clases del día actual utilizando una consulta avanzada (`JOIN`) para ver nombres en lugar de IDs.
* Utiliza **Listas Dinámicas** (`ListView.builder`) con un diseño de `Card` para cada clase.
* Implementa un **`BottomSheet`** avanzado para marcar "Asistió" o "Faltó" de forma rápida y elegante.

### 2. 📊 Reportes y Consultas
* Sección organizada por **`Tabs`** para visualizar consultas complejas:
    * **Consulta 1:** Buscar profesores por hora y edificio.
    * **Consulta 2:** Mostrar todos los profesores que asistieron en una fecha específica (seleccionada con `showDatePicker`).

### 3. 🗂️ Administración (CRUD)
* Accesible desde un **`Drawer`** (menú lateral).
* Gestiona las 4 tablas de la base de datos: `Profesor`, `Materia`, `Horario` y `Asistencia`.
* **Capturar:** Formularios limpios para insertar nuevos registros.
* **Mostrar/Actualizar/Eliminar:** Utiliza `Tabs` para organizar las 4 listas. Cada lista permite:
    * **Ver** todos los registros.
    * **Actualizar** un registro (navegando a la pantalla de captura en "modo edición").
    * **Eliminar** un registro con un diálogo de confirmación (`AlertDialog`).

---

## 💻 Tecnologías y Widgets Utilizados

* **Framework:** Flutter
* **Lenguaje:** Dart
* **Base de Datos:** `sqflite` (SQLite local)
* **Paquetes:** `intl` (para formato de fechas), `path`

### Widgets Avanzados Implementados
* `BottomNavigationBar` (Navegación principal)
* `Drawer` (Menú de administración)
* `TabBar` y `TabBarView` (Pestañas en Reportes y Administración)
* `showModalBottomSheet` (Pase de asistencia)
* `ListView.builder` (Listas dinámicas)
* `FutureBuilder` (Carga asíncrona de datos de la BD)
* `DropdownButtonFormField` (Selección de llaves foráneas en formularios)
* `showDatePicker` (Selector de fechas)
* `AlertDialog` (Confirmación de eliminación)

---

## 📦 Dependencias (pubspec.yaml)

El proyecto utiliza las siguientes dependencias de Dart y Flutter:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Para soporte de internacionalización y localización (fechas en español)
  flutter_localizations:
    sdk: flutter

  # Base de datos SQLite
  sqflite: ^2.4.2

  # Utilidad para encontrar la ruta de la base de datos
  path: ^1.9.1

  # Formateo de fechas y números
  intl: ^0.20.2
```

---

## 📂 Esquema de la Base de Datos (SQLite)

La aplicación utiliza 4 tablas relacionales con integridad referencial (`FOREIGN KEY` con `ON DELETE CASCADE`).

1.  **MATERIA** (`NMAT` (PK), `DESCRIPCION`)
2.  **PROFESOR** (`NPROFESOR` (PK), `NOMBRE`, `CARRERA`)
3.  **HORARIO** (`NHORARIO` (PK, AI), `NPROFESOR` (FK), `NMAT` (FK), `HORA`, `EDIFICIO`, `SALON`)
4.  **ASISTENCIA** (`IDASISTENCIA` (PK, AI), `NHORARIO` (FK), `FECHA`, `ASISTENCIA` (BOOLEAN))

---

## 🚀 Cómo Ejecutar el Proyecto

1.  Clona el repositorio:
    ```bash
    git clone https://github.com/JorgeVargas03/u3_practica2_checador.git
    ```
2.  Navega a la carpeta del proyecto:
    ```bash
    cd u3_practica2_checador
    ```
3.  Obtén las dependencias de Flutter:
    ```bash
    flutter pub get
    ```
4.  Ejecuta la aplicación en un emulador o dispositivo físico:
    ```bash
    flutter run
    ```
