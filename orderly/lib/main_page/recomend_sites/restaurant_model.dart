import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {

   final String promedio_entrega;
   final String descripcion_restaurante;
   final String Nombre;
   final String Foto;

  const RestaurantModel({
    required this.promedio_entrega,
    required this.descripcion_restaurante,
    required this.Nombre,
    required this.Foto

  });

  toJson() {
    return 
    {
    "Restaurante": Nombre,
    "Descripcion": descripcion_restaurante,
    "Promedio entrega": promedio_entrega,
    "foto": Foto
    };
  }
}

