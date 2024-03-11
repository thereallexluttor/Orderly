import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser!;
  late TabController _tabController;
  late List<QueryDocumentSnapshot> _restaurantesData = [];
  Position? _currentPosition; // Permitimos que _currentPosition sea nulo

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchRestaurantesData();
    _getCurrentLocation();
  }

  Future<void> _fetchRestaurantesData() async {
    final snapshot = await FirebaseFirestore.instance.collection('restaurantes').get();
    setState(() {
      _restaurantesData = snapshot.docs;
    });
  }

  void _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Deliciosa comida,\nrápida y sin filas! 😎',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Poppins-L",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  splashBorderRadius: BorderRadius.circular(20),
                  splashFactory: NoSplash.splashFactory,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: const [
                    Tab(text: "Para ti"),
                    Tab(text: "Buscar"),
                  ],
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontFamily: "Poppins-L",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                height: 500,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Contenido de la pestaña 'Para ti'
                    Column(
                      children: _restaurantesData.map((restauranteDoc) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: FutureBuilder<DocumentSnapshot>(
                            future: restauranteDoc.reference.collection('imagenes').doc('logo').get(),
                            builder: (context, logoSnapshot) {
                              if (logoSnapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              final logoUrl = logoSnapshot.data!['url'] as String;
                              return Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(logoUrl, width: 80, height: 80),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          '${restauranteDoc['nombre']}',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: "Poppins-L"),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(maxWidth: 250),
                                          child: Text('${restauranteDoc['descripcion']}', style: const TextStyle(fontSize: 8, fontFamily: "Poppins-L")),
                                        ),
                                        const SizedBox(height: 5),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Tiempo promedio de entrega: ',
                                                style: TextStyle(fontSize: 10, fontFamily: "Poppins", color: Colors.black, fontWeight: FontWeight.normal),
                                              ),
                                              TextSpan(
                                                text: ' ${restauranteDoc['time_order_mean']} min',
                                                style: const TextStyle(fontSize: 14, fontFamily: "Poppins", color: Colors.red, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    // Contenido de la pestaña 'Buscar'
                    const Text("Contenido de la pestaña 'Buscar'"),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _currentPosition != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Ubicación actual: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  : SizedBox(), // No mostramos nada si la ubicación aún no se ha obtenido
            ],
          ),
        ),
      ),
    );
  }
}

  
 // body: SafeArea(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [

      //       const Padding(
      //           padding: EdgeInsets.only(left: 22.0),
      //           child: Text(
      //             'Hoy podrás ordenar, sin filas y muy facil. 😎',
      //             textAlign: TextAlign.left,
      //             style: TextStyle(
      //               color: Colors.black,
      //               fontSize: 15,
      //               fontFamily: "Poppins-L"
      //             ),
      //           ),
      //         ),


      //       Text('home_page signed as ${user.email!}'),
      //       MaterialButton(
      //         onPressed: () {
      //           FirebaseAuth.instance.signOut();
      //         },
      //         color: Colors.purple,
      //         child: const Text(
      //           'Salir',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontFamily: "Poppins-L"),
      //         )
      //       )
      //     ],
      //   ), // Título de la página de registro
      // ),