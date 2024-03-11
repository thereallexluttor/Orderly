import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orderly/main_page/main_page.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LogAndSign extends StatelessWidget {
  LogAndSign({super.key});



  // Controladores para el campo de correo electrónico y contraseña
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  // Método para iniciar sesión
  Future signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailcontroller.text.trim(),
      password: _passwordcontroller.text.trim(),
    );
  }

  // Método para liberar recursos cuando el widget se elimina
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding:EdgeInsets.all(10.0),
    
                  child: Image(
                    image: AssetImage("lib/images/logos/orderly_icon2.png"),
                    height: 150,
                    width: 80,
                  
                ),
              ),
              const SizedBox(height: 150),
              const TextChangingWidget(),
              const Padding(
                padding: EdgeInsets.only(left: 22.0),
                child: Text(
                  'Hoy podrás ordenar, sin filas y muy facil. 😎',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: "Poppins-L"
                  ),
                ),
              ),
              const SizedBox(height: 43),
              const SizedBox(height: 30),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Ingresa aquí:',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: "Poppins-L"
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      signInWithGoogle();
                    },
                    // Utiliza un Row para alinear la imagen y el texto horizontalmente
                    child: const Row(
                      children: [
                        // La imagen del botón
                        Image(
                          image: AssetImage('lib/images/icons/google.png'),
                          width: 47, // Ajusta el tamaño según sea necesario
                          height: 24,
                        ),
                        // Agrega un espacio entre la imagen y el texto
                        
                        // El texto que deseas agregar al botón
                        Center(
                          child: Text(
                            'Iniciar sesión con Google   ',
                            style: TextStyle(
                              // Define el estilo del texto según tus preferencias
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: "Poppins-L"
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final credential = await SignInWithApple.getAppleIDCredential(
                        scopes: [
                          AppleIDAuthorizationScopes.email,
                          AppleIDAuthorizationScopes.fullName,
                        ],
                      );
                      // ignore: avoid_print
                      print(credential);
                    },
                    // Utiliza un Row para alinear la imagen y el texto horizontalmente
                    child: const Row(
                      children: [
                        // La imagen del botón
                        Image(
                          image: AssetImage('lib/images/icons/Apple.png'),
                          width: 57, // Ajusta el tamaño según sea necesario
                          height: 24,
                        ),
                        // Agrega un espacio entre la imagen y el texto
                        
                        // El texto que deseas agregar al botón
                        Center(
                          child: Text(
                            'Iniciar sesión con Apple    ',
                            style: TextStyle(
                              // Define el estilo del texto según tus preferencias
                              fontSize: 16,
                              fontFamily: "Poppins-L",
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      signInWithGoogle();
                    },
                    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Define el color de fondo del botón
                  ),
                    // Utiliza un Row para alinear la imagen y el texto horizontalmente
                    child: const Row(
                      children: [
                        // La imagen del botón
                        Image(
                          image: AssetImage('lib/images/icons/phone.png'),
                          width: 57, // Ajusta el tamaño según sea necesario
                          height: 24,
                        ),
                        // Agrega un espacio entre la imagen y el texto
                       
                        // El texto que deseas agregar al botón
                        Center(
                          child: Text(
                            'Ingresar con tu móvil        ',
                            style: TextStyle(
                              // Define el estilo del texto según tus preferencias
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: "Poppins-L"
                            ),
                          ),
                        ),
                      ],
                    )
                  )
              
            ],
          ),
        ]
        ),
        
      ),
    )
    );
  }

  // Método para mostrar la página de registro
  void showRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 130),
        pageBuilder: (_, __, ___) => const MainPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  // Método para iniciar sesión con Google
  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    // ignore: avoid_print
    print(userCredential.user?.displayName);
  }
}

class TextChangingWidget extends StatefulWidget {
  const TextChangingWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TextChangingWidgetState createState() => _TextChangingWidgetState();
}

class _TextChangingWidgetState extends State<TextChangingWidget> {
  int _index = 0;
  final List<String> _textList = ['Bienvenido!', 'Welcome!', '¡Salut!', 'Benvenuto!'];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _index = (_index + 1) % _textList.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0),
      child: Text(
        _textList[_index],
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontFamily: "Poppins-Bold"
        ),
      ),
    );
  }
}
