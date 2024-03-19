import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser!;
  late TabController _tabController;
  List<QueryDocumentSnapshot> _restaurantesData = [];
  Position? _currentPosition;
  Timer? _timer;
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _restaurantesParaTi = [];
  List<QueryDocumentSnapshot> _restaurantesFiltrados = [];
  List<QueryDocumentSnapshot> _restaurantesOfertas = [];
  final ScrollController _scrollController = ScrollController();
  final bool _scrollEnabled = false;
  int _selectedButtonIndex = -1;
  final List<String> _sliderImages = [
    "https://firebasestorage.googleapis.com/v0/b/orderly-33eb6.appspot.com/o/1.png?alt=media&token=0b010f6f-1709-4837-a852-199f0cd08a20",
    "https://firebasestorage.googleapis.com/v0/b/orderly-33eb6.appspot.com/o/2.png?alt=media&token=e5087d6e-f3e4-4a69-a9ac-ad7105b04e9a",
    "https://firebasestorage.googleapis.com/v0/b/orderly-33eb6.appspot.com/o/3.png?alt=media&token=524372db-78a1-4f4d-aaf8-5566ca76cbee",
    'https://firebasestorage.googleapis.com/v0/b/orderly-33eb6.appspot.com/o/4.png?alt=media&token=5de7a562-8f6d-4732-930f-fe780b465cda',
  ];

  int _currentSliderIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchRestaurantesDataFromCache();
    _getCurrentLocation();
    _startTimer();
    //_selectedButtonIndex = 0; //botonescomida
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 20), (timer) {
      if (_tabController.index == 0) {
        _fetchRestaurantesData();
        _getCurrentLocation();
      }
    });
  }

  Future<void> _fetchRestaurantesDataFromCache() async {
    if (_restaurantesData.isNotEmpty) return;
    final cachedData = await _getCachedRestaurantesData();
    if (cachedData.isNotEmpty) {
      setState(() {
        _restaurantesData = cachedData;
        _restaurantesParaTi = _restaurantesData;
        _restaurantesOfertas = _restaurantesData;
      });
    } else {
      _fetchRestaurantesData();
    }
  }

  Future<List<QueryDocumentSnapshot>> _getCachedRestaurantesData() async {
    return [];
  }

  void _cacheRestaurantesData(List<QueryDocumentSnapshot> data) {
    // Implementación del almacenamiento en caché
  }

  Future<void> _fetchRestaurantesData() async {
    final snapshot = await FirebaseFirestore.instance.collection('restaurantes').get();
    final restaurantesData = snapshot.docs;
    setState(() {
      _restaurantesData = restaurantesData;
      _restaurantesParaTi = _restaurantesData;
      _restaurantesOfertas = _restaurantesData;
    });
    _cacheRestaurantesData(restaurantesData);
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
              const SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 350,
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filtrarRestaurantes,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 50.0),
                          hintText: 'Busca tu restaurante favorito!',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins-L',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          const SizedBox(width: 20),
                          _buildButton(0, '🍔'),
                          const SizedBox(width: 8),
                          _buildButton(1, '🍕'),
                          const SizedBox(width: 8),
                          _buildButton(2, '🌮'),
                          const SizedBox(width: 8),
                          _buildButton(3, '🍗'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      height: 200,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayInterval: const Duration(seconds: 4),
                      enlargeCenterPage: true,
                      aspectRatio: 10.0,
                    ),
                    items: _sliderImages.map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.scaleDown,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  AnimatedSmoothIndicator(
                    activeIndex: _currentSliderIndex,
                    count: _sliderImages.length,
                    effect: const WormEffect(
                      dotHeight: 15,
                      dotWidth: 8,
                      spacing: 1,
                      dotColor: Colors.white,
                      activeDotColor:  Colors.white
                    ),
                  ),
                ],
              ),
              
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Restaurantes cercanos',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: "Poppins-L",
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Center(
               
                  child: Container(
                    height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height/1.15,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal, // Establecer el desplazamiento horizontal
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
                
                        return Container(
                          constraints: BoxConstraints(maxHeight: 20), // Establecer una altura máxima
                          child: _buildRestauranteCard(restauranteDoc, gpsPoint, distancia),
                        );
                      },
                    ),
                  ),
                
              ),

              const SizedBox(height: 15),
              Visibility(
                visible: _searchController.text.isEmpty,
                child: Center(
                child: Image.asset("lib/images/animations/Animation.gif",
                width: 300,
                height: 200,
                isAntiAlias: true,
                filterQuality: FilterQuality.high,
                )
                
                ),
              ),


              Visibility(
                 visible: _searchController.text.isNotEmpty,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Tu busqueda',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: "Poppins-L",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Center(
  child: Visibility(
    visible: _searchController.text.isNotEmpty,
    child: Container(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height/1.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Establecer el desplazamiento horizontal
        shrinkWrap: true,
        itemCount: _restaurantesFiltrados.length,
        itemBuilder: (context, index) {
          final restauranteDoc = _restaurantesFiltrados[index];
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
          
          return Container(
            constraints: BoxConstraints(maxHeight: 20), // Establecer una altura máxima
            child: _buildRestauranteCard(restauranteDoc, gpsPoint, distancia),
          );
        },
      ),
    ),
  ),
),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(top: 0.0),
          child: FloatingActionButton(
            onPressed: () {
              //QR-button
            },
            backgroundColor: const Color.fromARGB(250, 255, 255, 255),
            foregroundColor: const Color(0xFFB747EB),
            elevation: 7,
            shape: const CircleBorder(eccentricity: 0.5),
            child: const Icon(Icons.qr_code),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 7.0,
          shape: const CircularNotchedRectangle(),
          color: const Color.fromARGB(255, 255, 255, 255),
          height: 34,
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

  Widget _buildButton(int index, String text) {
    bool isSelected = index == _selectedButtonIndex;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedButtonIndex = index;
        });
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(80, 30),
        elevation: 1,
        side: const BorderSide(color: Color.fromARGB(255, 236, 236, 236)),
        backgroundColor: isSelected ? Color.fromARGB(255, 205, 117, 249) : Colors.white,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: isSelected ? Colors.white : const Color.fromARGB(255, 213, 213, 213),
          fontFamily: "Poppins-L",
        ),
      ),
    );
  }

  Widget _buildRestauranteCard(QueryDocumentSnapshot restauranteDoc, GeoPoint? gpsPoint, double distancia) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      child: FutureBuilder<DocumentSnapshot>(
        future: restauranteDoc.reference.collection('imagenes').doc('logo').get(),
        builder: (context, logoSnapshot) {
          if (logoSnapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }

          final logoUrl = logoSnapshot.data!['url'] as String;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 3,
                  offset: const Offset(0,7),
                ),
              ],
              color: Colors.white,
              border: Border.all(color: const Color.fromARGB(255, 229, 229, 229), width: 1),
              
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
                    fadeInDuration: Duration.zero,
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
                      constraints: const BoxConstraints(maxWidth: 200),
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

