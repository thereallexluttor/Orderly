
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Login_and_singup/singn_up.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orderly/Login_and_singup/my_button.dart';
import 'package:orderly/Login_and_singup/square_tile.dart';



class LogAndSign extends StatelessWidget {
  LogAndSign({super.key});

  void navigateToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }
  //set email and password vars
  final  TextEditingController _emailcontroller  = TextEditingController();
  final  TextEditingController _passwordcontroller = TextEditingController();

  Future signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailcontroller.text.trim(),
      password: _passwordcontroller.text.trim(),
       );
  }

@override
void dispose() {
  _emailcontroller.dispose();
  _passwordcontroller.dispose();
  //super.dispose();
}

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              const SizedBox(height: 30),
              const Center(
                child: 
                //logo
                Image(image: AssetImage("lib/images/logos/orderly_icon.png"),
                height: 200,
                width: 200,),
              ),
              const SizedBox(height: 20),
              // Texto que cambia cada 5 segundos
              const TextChangingWidget(),
              const Padding(
                padding:  EdgeInsets.only(left: 22.0),
                child: Text(
                  'Hoy podrás ordenar, sin filas y muy facil. 😎',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: "Poppins"
                  ),
                ),
              ),

              const SizedBox(height: 43),
              
              

              //username
               Padding(
                padding: const EdgeInsets.symmetric( horizontal: 25.0),
                child: TextField(
                  controller: _emailcontroller,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                    ),
                    fillColor: Color(0xFFF5F5F5), //FBFBFB
                    filled: true,
                    hintText: 'Correo electronico.',
                    hintStyle: TextStyle(fontSize: 15, 
                      color:  Colors.grey,
                      fontFamily: "Poppins-L"),
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  ),
                ),
              ),

              const SizedBox(height: 10),

               Padding(
                padding: const EdgeInsets.symmetric( horizontal: 25.0),
                child: TextField(
                  controller: _passwordcontroller,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    fillColor: Color(0xFFF5F5F5), //FBFBFB
                    filled: true,
                    hintText: 'Contrasena.',
                    hintStyle: TextStyle(fontSize: 15, 
                      color:  Colors.grey,
                      fontFamily: "Poppins-L"),
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  ),
                ),
              ),

              const SizedBox(height: 3),

              //SigIn Button
              MyButton(
                onTap: signUserIn,
              ),


              Padding( 
              padding: const EdgeInsets.all(15.0), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Olvidaste la contrasena?',
                    style: TextStyle(color: Colors.grey[600],
                    fontFamily: "Poppins-L")
                  ),
                ],
              )
            ),

            //o continuar con...

             // or continue with
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
                        'O continuar con:',
                        style: TextStyle(color: Colors.grey[700],
                        fontFamily: "Poppins-L"),
                        
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

              const SizedBox(height: 10),

              //google , apple
               const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  // google button
                  SquareTile(imagePath: 'lib/images/icons/google.png'),

                  SizedBox(width: 25),

                  // apple button
                  SquareTile(imagePath: 'lib/images/icons/Apple.png')
                ],
              ),

               const SizedBox(height: 20),

               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No tienes cuenta?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins-L'
                    ),
                  ),
                  GestureDetector(
                    onTap:() => showRegisterPage(context),
                    child: const Text(
                      ' Registrate aquí.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-L'
                      ),
                    ),
                  ),


                ],
              ),
          

              const SizedBox(height: 10),
              //forgot password
            
            ],
          ),
        ),
      ),
    );
  }

  

void showRegisterPage(BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 130), // Duración de la transición
      pageBuilder: (_, __, ___) => const RegisterPage(), // Constructor de la página de registro
      transitionsBuilder: (_, animation, __, child) {
        // Efecto de desvanecimiento durante la transición
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}





   // Agrega la función showRegisterPage aquí

}



class TextChangingWidget extends StatefulWidget {
  const TextChangingWidget({super.key});

  @override
  _TextChangingWidgetState createState() => _TextChangingWidgetState();
}

class _TextChangingWidgetState extends State<TextChangingWidget> {
  int _index = 0;
  final List<String> _textList = ['Bienvenido!', 'Welcome!', '¡Salut!', 'Benvenuto!'];

  @override
  void initState() {
    super.initState();
    // Inicia un temporizador que cambia el texto cada 5 segundos
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