import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orderly/main_page/main_page.dart';
import 'package:flutter/cupertino.dart';


import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LogAndSign extends StatelessWidget {
  LogAndSign({super.key});



  // Controladores para el campo de correo electrónico y contraseña
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _html_content = """
<blockquote class="tiktok-embed" cite="https://www.tiktok.com/@foodinbogota/video/7334363911250021637" data-video-id="7334363911250021637" style="max-width: 605px;min-width: 325px;" > <section> <a target="_blank" title="@foodinbogota" href="https://www.tiktok.com/@foodinbogota?refer=embed">@foodinbogota</a> Nadie tiene 4.9⭐️ en Google Maps por nada 📍Cll. 40B <a title="7" target="_blank" href="https://www.tiktok.com/tag/7?refer=embed">#7</a>-61 Se tenían el secreto bien guardado, pero afortunadamente, encontré a Aizu (@aizuramenbgta). Su chef es japonés, y se dedica a traer los sabores tradicionales de su país a este rinconcito muy cerca de la Javeriana. Su ramen es de los platos a los que más le echan flores sus clientes, pero yo me puse en la tarea de probar varias cosas para recomendárselas. 🙋🏽‍♀️Yo probé: 🍜SAPPORO MISO RAMEN - 💲33.900: Es un ramen a base de soya fermentada con cerdo cashu. Ya les he contando que no soy la mayor fan del ramen, pero puedo reconocer cuando hay uno bien hecho. Muchos fallan en la parte de condimentar el huevo, pero aquí lo hacen bien. Tiene un caldo DELICIOSO, buen cerdo, y buenos noodles. Les va a encantar. 🥘KATSU CURRY - 💲30.900: Curry japonés con cerdo apanado, arroz y salsa de la casa. Me gustó la estructura del plato, y estaba rico, aunque quizás el curry estaba más dulce de lo que me gustaría y no le sentí el picante (mi tolerancia es bastante alta). En todo caso, me parece un buen plato. 🍗KARAAGE - 💲18.500: No tenía ni cinco de ganas de pedirlo pero QUÉ MARAVILLA. Tienen que probarlo. El apanado del pollo es perfecto, está jugoso por dentro y tiene muchísimo sabor. Recomendadísimo. 🥟GYOZAS DE CERDO - 💲9.500 x 3 unidades: Además de ser deliciosas, quizás lo que más me sorprende es el precio. Recomendadísimas. Este restaurante es una joyita escondida (duélale a quien le duela jajajajaja). Sus precios me sorprendieron un montón, y es una excelente opción si estudian por la Javeriana. ✏️En resumen: Excelentes precios, excelente comida japonesa hecha por un japonés. 🇯🇵 Por nada del mundo se pierdan el pollo apanado.  <a title="restaurantesbogota" target="_blank" href="https://www.tiktok.com/tag/restaurantesbogota?refer=embed">#restaurantesbogota</a> <a title="comidabogota" target="_blank" href="https://www.tiktok.com/tag/comidabogota?refer=embed">#comidabogota</a> <a title="foodinbogota" target="_blank" href="https://www.tiktok.com/tag/foodinbogota?refer=embed">#foodinbogota</a> <a title="ramenbogota" target="_blank" href="https://www.tiktok.com/tag/ramenbogota?refer=embed">#ramenbogota</a> <a title="comidajaponesabogota" target="_blank" href="https://www.tiktok.com/tag/comidajaponesabogota?refer=embed">#comidajaponesabogota</a> <a title="planesbogota" target="_blank" href="https://www.tiktok.com/tag/planesbogota?refer=embed">#planesbogota</a> <a target="_blank" title="♬ pink and white frank ocean - sped up sounds" href="https://www.tiktok.com/music/pink-and-white-frank-ocean-7139629972091620139?refer=embed">♬ pink and white frank ocean - sped up sounds</a> </section> </blockquote> <script async src="https://www.tiktok.com/embed.js"></script>
""";
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
              
              const SizedBox(height: 100),
             // Html(data: "https://www.tiktok.com/@foodinbogota/video/7334363911250021637?is_from_webapp=1&sender_device=pc&web_id=7345493971261818401"),
              

              const Center(
                     child: Image(
                      image: AssetImage("lib/images/logos/orderly_icon.png"),
                      height: 200,
                      width: 200,
                    ),
              ),
              

              const SizedBox(height: 100),
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
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(260, 30),
                      elevation: 0 , 
                      side: const BorderSide(color: Color.fromARGB(255, 165, 165, 165)),
                      
                    ),
                    // Utiliza un Row para alinear la imagen y el texto horizontalmente
                    child: const Row(
                      children: [
                        // La imagen del botón
                        Image(
                          image: AssetImage('lib/images/icons/google.png'),
                          width: 47, // Ajusta el tamaño según sea necesario
                          height: 20,
                        ),
                        
                        // Agrega un espacio entre la imagen y el texto
                        
                        // El texto que deseas agregar al botón
                        Center(
                          child: Text(
                            'Iniciar sesión con Google',
                            style: TextStyle(
                              // Define el estilo del texto según tus preferencias
                              fontSize: 13,
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

                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(260, 30),
                      elevation: 0 , 
                      side: const BorderSide(color: Color.fromARGB(255, 165, 165, 165)),
                      
                    ),
                    // Utiliza un Row para alinear la imagen y el texto horizontalmente
                    child: const Row(
                      children: [
                        // La imagen del botón
                        Image(
                          image: AssetImage('lib/images/icons/Apple.png'),
                          width: 47, // Ajusta el tamaño según sea necesario
                          height: 20,
                        ),
                        // Agrega un espacio entre la imagen y el texto
                        
                        // El texto que deseas agregar al botón
                        Center(
                          child: Text(
                            'Iniciar sesión con Apple',
                            style: TextStyle(
                              // Define el estilo del texto según tus preferencias
                              fontSize: 13,
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
