import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // <-- 1. IMPORTA
import 'package:intl/date_symbol_data_local.dart'; // <-- 2. IMPORTA
import 'package:u3_practica2_checador/navegacion.dart'; // Tu home ahora es navegacion

void main() async { // <-- 3. CONVIERTE A ASYNC
  WidgetsFlutterBinding.ensureInitialized(); // <-- 4. AÑADE ESTA LÍNEA

  // --- 5. AÑADE ESTA LÍNEA PARA INICIALIZAR EL IDIOMA ---
  // Cargará los datos para español de México
  await initializeDateFormatting('es_MX', null);

  runApp(const MyApp()); // <-- 6. Cambia a MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checador App',
      theme: ThemeData( // <-- Opcional: Un tema unificado
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,

      // --- 7. AÑADE ESTAS 4 PROPIEDADES ---
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'MX'), // Soporte para Español de México
        const Locale('en', 'US'), // (Opcional) Soporte para Inglés
      ],
      locale: const Locale('es', 'MX'), // Forzar la app a iniciar en español

      home: NavegacionPage(), // <-- Tu pantalla de inicio con BottomNav
    );
  }
}