import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser!;
  late TabController _tabController;
  late List<QueryDocumentSnapshot> _restaurantesData = [];
  Position? _currentPosition; // Permitimos que _currentPosition sea nulo
  Timer? _timer;
  TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _restaurantesFiltrados = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchRestaurantesData();
    _getCurrentLocation();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 10), (timer) {
      if (_tabController.index == 0) {
        _fetchRestaurantesData();
        _getCurrentLocation(); // Actualiza la ubicación cada 2 minutos
      }
    });
  }

  Future<void> _fetchRestaurantesData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('restaurantes').get();
    setState(() {
      _restaurantesData = snapshot.docs;
      _restaurantesFiltrados = _restaurantesData; // Inicialmente, muestra todos los restaurantes
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
      // ignore: avoid_print
      print("Error al obtener la ubicación: $e");
    }
  }

  void _filtrarRestaurantes(String searchText) {
    setState(() {
      _restaurantesFiltrados = _restaurantesData.where((restaurante) {
        final nombre = restaurante['nombre'].toString().toLowerCase();
        return nombre.contains(searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
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
            Expanded( // Esta parte se expandirá para llenar el espacio restante
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Contenido de la pestaña 'Para ti'
                  ListView(
                    children: _restaurantesData.map((restauranteDoc) {
                      final gpsPoint =
                          restauranteDoc['gps_point'] as GeoPoint?;
                      double distancia = 0.0;

                      if (gpsPoint != null && _currentPosition != null) {
                        final distance = Geolocator.distanceBetween(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                          gpsPoint.latitude,
                          gpsPoint.longitude,
                        );
                        distancia =
                            distance / 1000; // Convertir metros a kilómetros
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: FutureBuilder<DocumentSnapshot>(
                          future: restauranteDoc.reference
                              .collection('imagenes')
                              .doc('logo')
                              .get(),
                          builder: (context, logoSnapshot) {
                            if (logoSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            final logoUrl =
                                logoSnapshot.data!['url'] as String;
                            return Container(
                              padding: const EdgeInsets.all(10),
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
                                    child:
                                        Image.network(logoUrl, width: 80, height: 80),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        '${restauranteDoc['nombre']}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins-L"),
                                      ),
                                      Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 250),
                                        child: Text(
                                            '${restauranteDoc['descripcion']}',
                                            style: const TextStyle(
                                                fontSize: 8,
                                                fontFamily: "Poppins-L")),
                                      ),
                                      const SizedBox(height: 5),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text:
                                                  'Tiempo promedio de entrega: ',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: "Poppins",
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            TextSpan(
                                              text:
                                                  ' ${restauranteDoc['time_order_mean']} min',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Poppins",
                                                  color: Colors.red,
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                            if (gpsPoint != null &&
                                                _currentPosition != null)
                                              TextSpan(
                                                text:
                                                    '\nDistancia: ${distancia.toStringAsFixed(2)} km',
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontFamily: "Poppins",
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
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
                  Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: _filtrarRestaurantes,
                        decoration: InputDecoration(
                          hintText: 'Buscar restaurante',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: _restaurantesFiltrados.map((restauranteDoc) {
                            final gpsPoint =
                                restauranteDoc['gps_point'] as GeoPoint?;
                            double distancia = 0.0;

                            if (gpsPoint != null && _currentPosition != null) {
                              final distance = Geolocator.distanceBetween(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                                gpsPoint.latitude,
                                gpsPoint.longitude,
                              );
                              distancia =
                                  distance / 1000; // Convertir metros a kilómetros
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: FutureBuilder<DocumentSnapshot>(
                                future: restauranteDoc.reference
                                    .collection('imagenes')
                                    .doc('logo')
                                    .get(),
                                builder: (context, logoSnapshot) {
                                  if (logoSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  final logoUrl =
                                      logoSnapshot.data!['url'] as String;
                                  return Container(
                                    padding: const EdgeInsets.all(10),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Text(
                                              '${restauranteDoc['nombre']}',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Poppins-L"),
                                            ),
                                            Container(
                                              constraints:
                                                  const BoxConstraints(maxWidth: 250),
                                              child: Text(
                                                  '${restauranteDoc['descripcion']}',
                                                  style: const TextStyle(
                                                      fontSize: 8,
                                                      fontFamily: "Poppins-L")),
                                            ),
                                            const SizedBox(height: 5),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text:
                                                        'Tiempo promedio de entrega: ',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontFamily: "Poppins",
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        ' ${restauranteDoc['time_order_mean']} min',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "Poppins",
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  if (gpsPoint != null &&
                                                      _currentPosition != null)
                                                    TextSpan(
                                                      text:
                                                          '\nDistancia: ${distancia.toStringAsFixed(2)} km',
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontFamily: "Poppins",
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal),
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color.fromARGB(250, 255, 255, 255),
          foregroundColor:  const Color(0xFFB747EB),
          elevation: 9,
          shape: const CircleBorder(eccentricity: 0.5),
          child: const Icon(Icons.qr_code),
        ),
        bottomNavigationBar: const BottomAppBar(
          notchMargin: 14.0,
          shape: CircularNotchedRectangle(),
          color: Color.fromARGB(0, 0, 0, 0),
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home,
                      color: Color(0xFFB747EB),
                      size: 20,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 10),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.discount,
                      color: Color(0xFFB747EB),
                      size: 20,
                    ),
                    Text(
                      "Ofertas",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 9, fontFamily: "Poppins"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

