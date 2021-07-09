import 'package:flutter/material.dart';
import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';

//Clase que realiza las operaciones CRUD de los propductos o actividades en la base de datos 
final ProductoActividadOperations _proActOper = new ProductoActividadOperations();

//provider para manejar el estado de los datos de los productos o actividades
class ProductoActividadData with ChangeNotifier {
  //Lista para almacenar los productos o actividades consultados a la base de datos
  List<ProductoActividadModel> productosActividades = [];
  //constructor que llama la funcion getProductoActividad para cargar los datos
  ProductoActividadData() {
    this.getProductoActividad();
  }
  //Función que accede a los registro de los productos o actividades por medio de la clase ProductoActividadOperations
  //declarada al inicio como _proActOper
  getProductoActividad() async {
    final resp = await _proActOper.consultarProductosActividadesOrder();
    this.productosActividades = [...resp];
    notifyListeners();
  }
}
