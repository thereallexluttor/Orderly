import 'package:flutter/material.dart';
import 'package:orderly/Login_and_singup/log_and_sing.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:orderly/main_page/main_page.dart';
import 'firebase_options.dart';


void main() async {
  // Inicializa Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Ejecuta la aplicación Flutter
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return const  MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: MainPage()

    );

    
  }
}

