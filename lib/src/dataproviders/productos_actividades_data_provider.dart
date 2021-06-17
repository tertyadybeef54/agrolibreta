import 'package:flutter/material.dart';

import 'package:agrolibreta_v2/src/modelos/producto_actividad_model.dart';
import 'package:agrolibreta_v2/src/data/producto_actividad_operations.dart';

 ProductoActividadOperations _proActOper = new ProductoActividadOperations();

//provider que cambia el valor del index del botton navigator bar
class ProductoActividadData with ChangeNotifier {
  List<ProductoActividadModel> productosActividades = [];

  ProductoActividadData() {
    this.getProductoActividad();
  }
  getProductoActividad() async {
    final resp = await _proActOper.consultarProductosActividadesOrder();
    this.productosActividades = [...resp];
    notifyListeners();
  }
}
