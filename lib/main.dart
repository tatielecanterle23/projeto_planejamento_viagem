import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;
import 'package:firebase_app/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'ViagemList.dart';
import 'firebase_options.dart';
import 'viagem_form.dart';

Future<void> main() async {
  // Inicialize o sqflite_ffi antes de executar o aplicativo
  sqflite_ffi.sqfliteFfiInit();

  WidgetsFlutterBinding.ensureInitialized();
  // conecta app com firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
    ),
    title: 'Planejamento de Viagem',
    home: LoginPage(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/viagemForm', // Defina a rota inicial conforme necessário
      routes: {
        '/viagemForm': (context) => ViagemForm(),
        '/viagemList': (context) => ViagemList(),
      },
    );
  }
}
