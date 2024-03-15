import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser!;
  late TabController _tabController;
  List<QueryDocumentSnapshot> _restaurantesData = [];
  Position? _currentPosition;
  Timer? _timer;
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _restaurantesParaTi = [];
  List<QueryDocumentSnapshot> _restaurantesFiltrados = [];
  List <QueryDocumentSnapshot> _restaurantesOfertas = [];
  final ScrollController _scrollController = ScrollController();
  final bool _scrollEnabled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchRestaurantesDataFromCache(); // Intentamos cargar desde caché primero
    _getCurrentLocation();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      if (_tabController.index == 0) {
        _fetchRestaurantesData();
        _getCurrentLocation();
      }
    });
  }

  Future<void> _fetchRestaurantesDataFromCache() async {
    // Intentamos cargar desde caché primero
    if (_restaurantesData.isNotEmpty) return;
    final cachedData = await _getCachedRestaurantesData();
    if (cachedData.isNotEmpty) {
      setState(() {
        _restaurantesData = cachedData;
        _restaurantesParaTi = _restaurantesData;
        _restaurantesOfertas = _restaurantesData; // Mostrar datos almacenados en caché
      });
    } else {
      _fetchRestaurantesData(); // Si no hay datos en caché, cargamos desde Firestore
    }
  }

  Future<List<QueryDocumentSnapshot>> _getCachedRestaurantesData() async {
    // Implementación de la obtención de datos desde caché (puedes utilizar Shared Preferences o Hive, por ejemplo)
    // Aquí un ejemplo simple utilizando SharedPreferences
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final restaurantesData = prefs.getStringList('restaurantesData') ?? [];
    // return restaurantesData.map((jsonData) => jsonDecode(jsonData)).toList();
    return [];
  }

  void _cacheRestaurantesData(List<QueryDocumentSnapshot> data) {
    // Implementación del almacenamiento en caché (puedes utilizar Shared Preferences o Hive, por ejemplo)
    // Aquí un ejemplo simple utilizando SharedPreferences
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final jsonDataList = data.map((doc) => jsonEncode(doc.data())).toList();
    // prefs.setStringList('restaurantesData', jsonDataList);
  }

  Future<void> _fetchRestaurantesData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('restaurantes').get();
    final restaurantesData = snapshot.docs;
    setState(() {
      _restaurantesData = restaurantesData;
      _restaurantesParaTi = _restaurantesData;
      _restaurantesOfertas = _restaurantesData; // Mostrar datos nuevos desde Firestore
    });
    _cacheRestaurantesData(restaurantesData); // Almacenar datos en caché para uso futuro
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
      _restaurantesFiltrados = _restaurantesParaTi.where((restaurante) {
        final nombre = restaurante['nombre'].toString().toLowerCase();
        return nombre.contains(searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: _scrollController,
          physics: _scrollEnabled ? null : const NeverScrollableScrollPhysics(),
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
                  tabs: const [
                    Tab(text: "Para ti"),
                    Tab(text: "Buscar"),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height/2.5 ,//MediaQuery.of(context).size.height/5  - MediaQuery.of(context).size.height/4.5, //distancia de la bottombar 360
                child: Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Contenido de la pestaña 'Para ti'
                      ListView.builder(
                        itemCount: _restaurantesParaTi.length,
                        itemBuilder: (context, index) {
                          final restauranteDoc = _restaurantesParaTi[index];
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

                          return _buildRestauranteCard(
                              restauranteDoc, gpsPoint, distancia);
                        },
                      ),
                      // Contenido de la pestaña 'Buscar'
                      Column(
                        children: [
                          TextField(
                            controller: _searchController,
                            onChanged: _filtrarRestaurantes,
                            decoration: const InputDecoration(
                              hintText: 'Buscar restaurante',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _restaurantesFiltrados.length,
                              itemBuilder: (context, index) {
                                final restauranteDoc =
                                    _restaurantesFiltrados[index];
                                final gpsPoint =
                                    restauranteDoc['gps_point'] as GeoPoint?;
                                double distancia = 0.0;

                                if (gpsPoint != null &&
                                    _currentPosition != null) {
                                  final distance = Geolocator.distanceBetween(
                                    _currentPosition!.latitude,
                                    _currentPosition!.longitude,
                                    gpsPoint.latitude,
                                    gpsPoint.longitude,
                                  );
                                  distancia =
                                      distance / 1000; // Convertir metros a kilómetros
                                }

                                return _buildRestauranteCard(
                                    restauranteDoc, gpsPoint, distancia);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 80//MediaQuery.of(context).size.height/2 
                //tenia un valor restado -320
              ),
               SizedBox(
  height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height/5 , // Altura ajustable según sea necesario
  child: SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Estos son los productos en oferta hoy! 😜',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontFamily: "Poppins-L",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _restaurantesParaTi.length,
            itemBuilder: (context, index) {
              final restauranteDoc = _restaurantesParaTi[index];
              final gpsPoint = restauranteDoc['gps_point'] as GeoPoint?;
              double distancia = 0.0;

              if (gpsPoint != null && _currentPosition != null) {
                final distance = Geolocator.distanceBetween(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                  gpsPoint.latitude,
                  gpsPoint.longitude,
                );
                distancia = distance / 1000; // Convertir metros a kilómetros
              }

              return _buildRestauranteCard(
                  restauranteDoc, gpsPoint, distancia);
            },
          ),
        ),
      ],
    ),
  ),
),


            ],
          ),
          
        ),


        
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
floatingActionButton: Container(
  margin: EdgeInsets.only(top: 50.0), // Ajusta el margen inferior según sea necesario
  child: FloatingActionButton(
    onPressed: () {
      if (_tabController.index == 1) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        _scrollController.animateTo(
          8.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    },
    backgroundColor: const Color.fromARGB(250, 255, 255, 255),
    foregroundColor: const Color(0xFFB747EB),
    elevation: 10,
    shape: const CircleBorder(eccentricity: 0.5),
    child: const Icon(Icons.qr_code),
  ),
),
bottomNavigationBar: BottomAppBar(
  notchMargin: 3.0,
  shape: const CircularNotchedRectangle(),
   color: Color.fromARGB(255, 255, 255, 255),
  
  height: 64, // Tamaño de la bottombar
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    mainAxisSize: MainAxisSize.max,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 0.0),
        child: InkWell(
          onTap: () {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.home,
                color: Color(0xFFB747EB),
                size: 20,
              ),
              Text(
                "Home",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 10),
              )
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: InkWell(
          onTap: () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.discount,
                color: Color(0xFFB747EB),
                size: 20,
              ),
              Text(
                "Ofertas",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 9,
                    fontFamily: "Poppins"),
              )
            ],
          ),
        ),
      ),
    ],
  ),
),

      ),
    );
  }

  Widget _buildRestauranteCard(
      QueryDocumentSnapshot restauranteDoc, GeoPoint? gpsPoint, double distancia) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: FutureBuilder<DocumentSnapshot>(
        future: restauranteDoc.reference.collection('imagenes').doc('logo').get(),
        builder: (context, logoSnapshot) {
          if (logoSnapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink(); // Evita renderizar espacio para la animación de carga
          }

          final logoUrl = logoSnapshot.data!['url'] as String;
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
                  child: CachedNetworkImage(
                    imageUrl: logoUrl,
                    width: 80,
                    height: 80,
                    placeholder: (context, url) => const SizedBox.shrink(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fadeInDuration: Duration.zero, // Sin animación de carga
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      '${restauranteDoc['nombre']}',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins-L"),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 250),
                      child: Text(
                          '${restauranteDoc['descripcion']}',
                          style: const TextStyle(
                              fontSize: 9, fontFamily: "Poppins-L")),
                    ),
                    const SizedBox(height: 0),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Tiempo promedio de entrega: ',
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: "Poppins",
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: ' ${restauranteDoc['time_order_mean']} min',
                            style: const TextStyle(
                                fontSize: 11,
                                fontFamily: "Poppins",
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                          if (gpsPoint != null && _currentPosition != null)
                            TextSpan(
                              text:
                                  '\nDistancia: ${distancia.toStringAsFixed(2)} km',
                              style: const TextStyle(
                                  fontSize: 9,
                                  fontFamily: "Poppins",
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
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
  }
}
