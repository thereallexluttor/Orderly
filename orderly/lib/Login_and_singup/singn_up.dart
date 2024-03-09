import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orderly/Login_and_singup/my_button_signup.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // Set email and password vars
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  Future<void> signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailcontroller.text.trim(),
      password: _passwordcontroller.text.trim(),
    );
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

              IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
            iconSize: 30, // Tamaño del ícono
          ),
              const SizedBox(height: 1),
              const Center(
                child: Image(
                  image: AssetImage("lib/images/logos/orderly_icon.png"),
                  height: 210,
                  width: 220,
                ),
              ),
            



              const _TextChangingWidgetState2(),
              const Padding(
                padding: EdgeInsets.only(left: 22.0),
                child: Text(
                  'Hoy se acaban las filas y las esperas eternas. 😎',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _emailcontroller, // Add controller here
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                    ),
                    fillColor: Color(0xFFF5F5F5), //FBFBFB
                    filled: true,
                    hintText: 'Correo electrónico.',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontFamily: "Poppins-L",
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _passwordcontroller, // Add controller here
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    fillColor: Color(0xFFF5F5F5), //FBFBFB
                    filled: true,
                    hintText: 'Contraseña.',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontFamily: "Poppins-L",
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              // SignIn Button
              MyButton2(
                onTap: signUserIn,
              ),


             const SizedBox(height: 30),


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
              
              const SizedBox(height: 25),

              //google , apple
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  // google button
                  Center(
                    child: ElevatedButton(
                      
                      //imagePath: 'lib/images/icons/google.png',
                      onPressed:  ()  {
                        signInWithGoogle();
                      },
                       child: 
                       const Image(image: AssetImage('lib/images/icons/google.png'),
                       width: 24,
                       height: 24,
                       )

                      ),
                  ),

                  const SizedBox(width: 25),

                  // apple button
                  Center(
                    child: ElevatedButton(
                     // imagePath: 'lib/images/icons/Apple.png',
                      onPressed: () {
                       
                      },
                      child:const Image(image: AssetImage('lib/images/icons/Apple.png'),
                       width: 24,
                       height: 24,
                       )
                      
                       ,),
                  )
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
  
   signInWithGoogle() async{
     GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

     GoogleSignInAuthentication? googleAuth =await googleUser?.authentication;


    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );

    UserCredential userCredential =await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);

    
    }
    
  }
   // Agrega la función showRegisterPage aquí




class _TextChangingWidgetState2 extends StatefulWidget {
  const _TextChangingWidgetState2();

  @override
  __TextChangingWidgetState2State createState() => __TextChangingWidgetState2State();
}

class __TextChangingWidgetState2State extends State<_TextChangingWidgetState2> {
  int _index = 0;
  final List<String> _textList = ['¡Regístrate!', 'Register!', 'Inscrivez-vous!', 'Registrati!'];

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
